import 'package:equatable/equatable.dart';

abstract class IpInfoEvent extends Equatable {
  const IpInfoEvent();
  @override
  List<Object?> get props => [];
}

class LoadIpOccupancy extends IpInfoEvent {}
