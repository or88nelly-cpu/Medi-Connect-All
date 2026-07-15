import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/entities/ip_occupancy_entity.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/repositories/ip_info_repository.dart';

@lazySingleton
class GetIpOccupancyUseCase {
  final IpInfoRepository repository;

  GetIpOccupancyUseCase(this.repository);

  Future<Either<Failure, List<IpOccupancyEntity>>> call() {
    return repository.getIpOccupancy();
  }
}
