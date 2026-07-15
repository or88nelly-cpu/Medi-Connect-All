import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctor/op_info/domain/entities/op_info_summary_entity.dart';
import 'package:medi_connect/features/doctor/op_info/domain/entities/op_procedure_entity.dart';

abstract class OpInfoState extends Equatable {
  const OpInfoState();

  @override
  List<Object?> get props => [];
}

class OpInfoInitial extends OpInfoState {
  const OpInfoInitial();
}

class OpInfoLoading extends OpInfoState {
  const OpInfoLoading();
}

class OpInfoLoaded extends OpInfoState {
  final OpInfoSummaryEntity summary;
  final List<OpProcedureEntity> filteredProcedures;
  final DateTime selectedDate;
  final String searchQuery;
  final String activeFilter;
  final String doctorId;

  const OpInfoLoaded({
    required this.summary,
    required this.filteredProcedures,
    required this.selectedDate,
    required this.searchQuery,
    required this.activeFilter,
    required this.doctorId,
  });

  OpInfoLoaded copyWith({
    OpInfoSummaryEntity? summary,
    List<OpProcedureEntity>? filteredProcedures,
    DateTime? selectedDate,
    String? searchQuery,
    String? activeFilter,
    String? doctorId,
  }) {
    return OpInfoLoaded(
      summary: summary ?? this.summary,
      filteredProcedures: filteredProcedures ?? this.filteredProcedures,
      selectedDate: selectedDate ?? this.selectedDate,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
      doctorId: doctorId ?? this.doctorId,
    );
  }

  @override
  List<Object?> get props => [
    summary,
    filteredProcedures,
    selectedDate,
    searchQuery,
    activeFilter,
    doctorId,
  ];
}

class OpInfoError extends OpInfoState {
  final String message;

  const OpInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
