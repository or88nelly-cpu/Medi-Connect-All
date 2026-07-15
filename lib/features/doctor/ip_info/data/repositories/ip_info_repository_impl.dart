import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/ip_info/data/datasources/ip_info_remote_datasource.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/entities/ip_occupancy_entity.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/repositories/ip_info_repository.dart';

@LazySingleton(as: IpInfoRepository)
class IpInfoRepositoryImpl implements IpInfoRepository {
  final IpInfoRemoteDataSource remoteDataSource;

  IpInfoRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<IpOccupancyEntity>>> getIpOccupancy() async {
    try {
      final result = await remoteDataSource.getIpOccupancy();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
