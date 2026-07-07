
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctors/ip_info/domain/entities/ip_occupancy_entity.dart';

abstract class IpInfoRepository {
  Future<Either<Failure, List<IpOccupancyEntity>>> getIpOccupancy();
}
