import 'package:equatable/equatable.dart';

abstract class OpInfoEvent extends Equatable {
  const OpInfoEvent();

  @override
  List<Object?> get props => [];
}

class OpInfoLoadRequested extends OpInfoEvent {
  final String doctorId;
  final DateTime date;

  const OpInfoLoadRequested({required this.doctorId, required this.date});

  @override
  List<Object?> get props => [doctorId, date];
}

class OpInfoDateChanged extends OpInfoEvent {
  final DateTime date;

  const OpInfoDateChanged(this.date);

  @override
  List<Object?> get props => [date];
}

class OpInfoSearchChanged extends OpInfoEvent {
  final String query;

  const OpInfoSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class OpInfoFilterChanged extends OpInfoEvent {
  final String filter;

  const OpInfoFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class OpInfoPreviousDay extends OpInfoEvent {
  const OpInfoPreviousDay();
}

class OpInfoNextDay extends OpInfoEvent {
  const OpInfoNextDay();
}
