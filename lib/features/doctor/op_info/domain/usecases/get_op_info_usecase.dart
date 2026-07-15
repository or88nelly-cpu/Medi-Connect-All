import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/op_info/domain/entities/op_info_summary_entity.dart';
import 'package:medi_connect/features/doctor/op_info/domain/repositories/op_info_repository.dart';

class GetOpInfoParams extends Equatable {
  final String doctorId;
  final DateTime date;

  const GetOpInfoParams({required this.doctorId, required this.date});

  @override
  List<Object?> get props => [doctorId, date];
}

@lazySingleton
class GetOpInfoUseCase extends UseCase<OpInfoSummaryEntity, GetOpInfoParams> {
  final OpInfoRepository _repository;

  const GetOpInfoUseCase(this._repository);

  @override
  Future<Either<Failure, OpInfoSummaryEntity>> call(GetOpInfoParams params) {
    return _repository.getOpInfo(doctorId: params.doctorId, date: params.date);
  }
}
