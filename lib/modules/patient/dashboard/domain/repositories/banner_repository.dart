import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/entities/banner_entity.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getActiveBanners();
}
