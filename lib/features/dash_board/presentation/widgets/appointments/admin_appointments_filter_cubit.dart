import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAppointmentsFilterState {
  final String searchQuery;
  final String filterStatus;
  final DateTime selectedDate;

  const AdminAppointmentsFilterState({
    required this.searchQuery,
    required this.filterStatus,
    required this.selectedDate,
  });

  AdminAppointmentsFilterState copyWith({
    String? searchQuery,
    String? filterStatus,
    DateTime? selectedDate,
  }) {
    return AdminAppointmentsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class AdminAppointmentsFilterCubit extends Cubit<AdminAppointmentsFilterState> {
  AdminAppointmentsFilterCubit()
    : super(
        AdminAppointmentsFilterState(
          searchQuery: '',
          filterStatus: 'All',
          selectedDate: DateTime.now(),
        ),
      );

  void changeSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void changeFilterStatus(String status) {
    emit(state.copyWith(filterStatus: status));
  }

  void changeSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void resetFilters() {
    emit(
      AdminAppointmentsFilterState(
        searchQuery: '',
        filterStatus: 'All',
        selectedDate: DateTime.now(),
      ),
    );
  }
}
