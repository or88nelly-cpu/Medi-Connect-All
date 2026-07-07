import 'package:equatable/equatable.dart';

abstract class PendingMrdEvent extends Equatable {
  const PendingMrdEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingMrdEvent extends PendingMrdEvent {
  final String userId;

  const LoadPendingMrdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SetCategoryEvent extends PendingMrdEvent {
  final String category;

  const SetCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SetSearchQueryEvent extends PendingMrdEvent {
  final String query;

  const SetSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SetAreaFilterEvent extends PendingMrdEvent {
  final String area;

  const SetAreaFilterEvent(this.area);

  @override
  List<Object?> get props => [area];
}

class SetPriorityFilterEvent extends PendingMrdEvent {
  final String priority;

  const SetPriorityFilterEvent(this.priority);

  @override
  List<Object?> get props => [priority];
}

class SetStatusFilterEvent extends PendingMrdEvent {
  final String status;

  const SetStatusFilterEvent(this.status);

  @override
  List<Object?> get props => [status];
}

class ChangeDateEvent extends PendingMrdEvent {
  final int offset;

  const ChangeDateEvent(this.offset);

  @override
  List<Object?> get props => [offset];
}
