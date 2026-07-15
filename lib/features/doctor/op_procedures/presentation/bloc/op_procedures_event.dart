import 'package:equatable/equatable.dart';

abstract class OpProceduresEvent extends Equatable {
  const OpProceduresEvent();
  @override
  List<Object?> get props => [];
}

class LoadOpProcedures extends OpProceduresEvent {}
