import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/models/mrd_record_display_model.dart';

abstract class PendingMrdState extends Equatable {
  const PendingMrdState();

  @override
  List<Object?> get props => [];
}

class PendingMrdInitial extends PendingMrdState {}

class PendingMrdLoading extends PendingMrdState {}

class PendingMrdLoaded extends PendingMrdState {
  final List<MrdRecordDisplayModel> allRecords;
  final List<MrdRecordDisplayModel> filteredRecords;
  final DateTime selectedDate;
  final String
  selectedCategory; // 'All Pending', 'Discharge Summary', 'Operative Notes', 'Signatures', 'Overdue', 'Returned'
  final String searchQuery;
  final String selectedArea;
  final String selectedPriority;
  final String selectedStatus;
  final Map<String, int> counts;

  const PendingMrdLoaded({
    required this.allRecords,
    required this.filteredRecords,
    required this.selectedDate,
    required this.selectedCategory,
    required this.searchQuery,
    required this.selectedArea,
    required this.selectedPriority,
    required this.selectedStatus,
    required this.counts,
  });

  PendingMrdLoaded copyWith({
    List<MrdRecordDisplayModel>? allRecords,
    List<MrdRecordDisplayModel>? filteredRecords,
    DateTime? selectedDate,
    String? selectedCategory,
    String? searchQuery,
    String? selectedArea,
    String? selectedPriority,
    String? selectedStatus,
    Map<String, int>? counts,
  }) {
    return PendingMrdLoaded(
      allRecords: allRecords ?? this.allRecords,
      filteredRecords: filteredRecords ?? this.filteredRecords,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      counts: counts ?? this.counts,
    );
  }

  @override
  List<Object?> get props => [
    allRecords,
    filteredRecords,
    selectedDate,
    selectedCategory,
    searchQuery,
    selectedArea,
    selectedPriority,
    selectedStatus,
    counts,
  ];
}

class PendingMrdError extends PendingMrdState {
  final String message;

  const PendingMrdError(this.message);

  @override
  List<Object?> get props => [message];
}
