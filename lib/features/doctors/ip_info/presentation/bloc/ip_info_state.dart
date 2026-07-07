import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctors/ip_info/domain/entities/ip_occupancy_entity.dart';

abstract class IpInfoState extends Equatable {
  const IpInfoState();
  @override
  List<Object?> get props => [];
}

class IpInfoInitial extends IpInfoState {}

class IpInfoLoading extends IpInfoState {}

class IpInfoLoaded extends IpInfoState {
  final List<IpOccupancyEntity> occupancyList;
  const IpInfoLoaded(this.occupancyList);

  @override
  List<Object?> get props => [occupancyList];
}

class IpInfoError extends IpInfoState {
  final String message;
  const IpInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
