import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_info_summary_entity.dart';

abstract class OpInfoRepository {
  Future<Either<Failure, OpInfoSummaryEntity>> getOpInfo({
    required String doctorId,
    required DateTime date,
  });
}
