import 'dart:developer' as developer;
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/constants/app_table_names.dart';
import 'package:medi_connect/modules/patient/dashboard/data/models/banner_model.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/entities/banner_entity.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final SupabaseService _supabase;

  BannerRepositoryImpl(this._supabase);

  @override
  Future<Either<Failure, List<BannerEntity>>> getActiveBanners() async {
    try {
      final response = await _supabase
          .from(AppTableNames.banners)
          .select()
          .eq('is_active', true)
          .order('display_order', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final banners = data
          .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(banners);
    } catch (e, stackTrace) {
      developer.log(
        "Exception in getActiveBanners",
        error: e,
        stackTrace: stackTrace,
        name: "BannerRepository",
      );
      return Left(ServerFailure(e.toString()));
    }
  }
}
