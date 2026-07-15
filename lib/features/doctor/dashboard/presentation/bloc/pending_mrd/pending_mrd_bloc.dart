import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/usecases/get_pending_mrd_records_usecase.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_event.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_state.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/models/mrd_record_display_model.dart';

@injectable
class PendingMrdBloc extends Bloc<PendingMrdEvent, PendingMrdState> {
  final GetPendingMrdRecordsUseCase _getPendingMrdRecordsUseCase;

  PendingMrdBloc(this._getPendingMrdRecordsUseCase)
    : super(PendingMrdInitial()) {
    on<LoadPendingMrdEvent>(_onLoadPendingMrd);
    on<SetCategoryEvent>(_onSetCategory);
    on<SetSearchQueryEvent>(_onSetSearchQuery);
    on<SetAreaFilterEvent>(_onSetAreaFilter);
    on<SetPriorityFilterEvent>(_onSetPriorityFilter);
    on<SetStatusFilterEvent>(_onSetStatusFilter);
    on<ChangeDateEvent>(_onChangeDate);
  }

  Future<void> _onLoadPendingMrd(
    LoadPendingMrdEvent event,
    Emitter<PendingMrdState> emit,
  ) async {
    emit(PendingMrdLoading());
    final result = await _getPendingMrdRecordsUseCase(event.userId);

    result.fold((failure) => emit(PendingMrdError(failure.message)), (records) {
      final List<MrdRecordDisplayModel> displayModels = [];

      for (final rec in records) {
        String pendingAt = rec.recordType;

        String priority = 'Medium';
        if (rec.createdAt != null) {
          final hoursPending = DateTime.now().difference(rec.createdAt!).inHours;
          if (hoursPending >= 48) {
            priority = 'High';
          } else if (hoursPending >= 24) {
            priority = 'Medium';
          } else {
            priority = 'Low';
          }
        }

        String pendingSince = '1h';
        if (rec.createdAt != null) {
          final diff = DateTime.now().difference(rec.createdAt!);
          if (diff.inDays > 0) {
            pendingSince = '${diff.inDays}d';
          } else if (diff.inHours > 0) {
            pendingSince = '${diff.inHours}h ${diff.inMinutes % 60}m';
          } else {
            pendingSince = '${diff.inMinutes}m';
          }
        }

        displayModels.add(
          MrdRecordDisplayModel(
            record: rec,
            patientName: rec.patientName ?? 'Arjun Nambiar',
            patientAge: rec.patientAge ?? '30',
            patientGender: rec.patientGender ?? 'Male',
            patientPhoto: rec.patientPhoto,
            ipdLocation: pendingAt,
            pendingSince: pendingSince,
            priority: priority,
          ),
        );
      }

      final counts = _calculateCounts(displayModels);

      emit(
        PendingMrdLoaded(
          allRecords: displayModels,
          filteredRecords: displayModels,
          selectedDate: DateTime(2026, 6, 27),
          selectedCategory: 'All Pending',
          searchQuery: '',
          selectedArea: 'All Areas',
          selectedPriority: 'All Priorities',
          selectedStatus: 'All Status',
          counts: counts,
        ),
      );
    });
  }

  void _onSetCategory(SetCategoryEvent event, Emitter<PendingMrdState> emit) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final filtered = _applyFilters(
        currentState.allRecords,
        event.category,
        currentState.searchQuery,
        currentState.selectedArea,
        currentState.selectedPriority,
        currentState.selectedStatus,
      );
      emit(
        currentState.copyWith(
          selectedCategory: event.category,
          filteredRecords: filtered,
        ),
      );
    }
  }

  void _onSetSearchQuery(
    SetSearchQueryEvent event,
    Emitter<PendingMrdState> emit,
  ) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final filtered = _applyFilters(
        currentState.allRecords,
        currentState.selectedCategory,
        event.query,
        currentState.selectedArea,
        currentState.selectedPriority,
        currentState.selectedStatus,
      );
      emit(
        currentState.copyWith(
          searchQuery: event.query,
          filteredRecords: filtered,
        ),
      );
    }
  }

  void _onSetAreaFilter(
    SetAreaFilterEvent event,
    Emitter<PendingMrdState> emit,
  ) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final filtered = _applyFilters(
        currentState.allRecords,
        currentState.selectedCategory,
        currentState.searchQuery,
        event.area,
        currentState.selectedPriority,
        currentState.selectedStatus,
      );
      emit(
        currentState.copyWith(
          selectedArea: event.area,
          filteredRecords: filtered,
        ),
      );
    }
  }

  void _onSetPriorityFilter(
    SetPriorityFilterEvent event,
    Emitter<PendingMrdState> emit,
  ) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final filtered = _applyFilters(
        currentState.allRecords,
        currentState.selectedCategory,
        currentState.searchQuery,
        currentState.selectedArea,
        event.priority,
        currentState.selectedStatus,
      );
      emit(
        currentState.copyWith(
          selectedPriority: event.priority,
          filteredRecords: filtered,
        ),
      );
    }
  }

  void _onSetStatusFilter(
    SetStatusFilterEvent event,
    Emitter<PendingMrdState> emit,
  ) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final filtered = _applyFilters(
        currentState.allRecords,
        currentState.selectedCategory,
        currentState.searchQuery,
        currentState.selectedArea,
        currentState.selectedPriority,
        event.status,
      );
      emit(
        currentState.copyWith(
          selectedStatus: event.status,
          filteredRecords: filtered,
        ),
      );
    }
  }

  void _onChangeDate(ChangeDateEvent event, Emitter<PendingMrdState> emit) {
    final currentState = state;
    if (currentState is PendingMrdLoaded) {
      final nextDate = currentState.selectedDate.add(
        Duration(days: event.offset),
      );
      emit(currentState.copyWith(selectedDate: nextDate));
    }
  }

  Map<String, int> _calculateCounts(List<MrdRecordDisplayModel> items) {
    int discharge = 0;
    int operative = 0;
    int signatures = 0;
    int overdue = 0;
    int returned = 0;
    int consultation = 0;

    for (final item in items) {
      final type = item.record.recordType.toLowerCase();
      if (type == 'discharge summary') {
        discharge++;
      } else if (type == 'operative notes') {
        operative++;
      } else if (type == 'digital signature') {
        signatures++;
      } else if (type == 'consultation') {
        consultation++;
      }

      if (item.priority == 'High') {
        overdue++;
      } else if (item.priority == 'Low') {
        returned++;
      }
    }

    return {
      'discharge': discharge,
      'operative': operative,
      'signatures': signatures,
      'consultation': consultation,
      'overdue': overdue,
      'returned': returned,
      'total': items.length,
    };
  }

  List<MrdRecordDisplayModel> _applyFilters(
    List<MrdRecordDisplayModel> items,
    String category,
    String query,
    String area,
    String priority,
    String status,
  ) {
    return items.where((item) {
      if (category != 'All Pending') {
        final type = item.record.recordType.toLowerCase();
        if (category == 'Discharge Summary' && type != 'discharge summary') {
          return false;
        }
        if (category == 'Operative Notes' && type != 'operative notes') {
          return false;
        }
        if (category == 'Signatures' && type != 'digital signature') {
          return false;
        }
        if (category == 'Consultation' && type != 'consultation') {
          return false;
        }
        if (category == 'Overdue' && item.priority.toLowerCase() != 'high') {
          return false;
        }
        if (category == 'Returned' && item.priority.toLowerCase() != 'low') {
          return false;
        }
      }

      if (query.isNotEmpty) {
        final matchesName = item.patientName.toLowerCase().contains(
          query.toLowerCase(),
        );
        final matchesMrd = item.ipdLocation.toLowerCase().contains(
          query.toLowerCase(),
        );
        if (!matchesName && !matchesMrd) return false;
      }

      if (priority != 'All Priorities') {
        if (item.priority.toLowerCase() !=
            priority.replaceAll('Priority', '').trim().toLowerCase())
          return false;
      }

      if (area != 'All Areas') {
        if (!item.ipdLocation.toLowerCase().contains(
          area.toLowerCase().replaceAll('area', '').trim(),
        ))
          return false;
      }

      return true;
    }).toList();
  }
}
