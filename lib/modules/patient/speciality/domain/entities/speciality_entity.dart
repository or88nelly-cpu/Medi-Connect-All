import 'package:equatable/equatable.dart';

class SpecialityEntity extends Equatable {
  final String id;
  final String specialityCode;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? icon;
  final int consultationDuration;
  final double? defaultConsultationFee;
  final bool isSurgical;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SpecialityEntity({
    required this.id,
    required this.specialityCode,
    required this.name,
    this.description,
    this.imageUrl,
    this.icon,
    this.consultationDuration = 15,
    this.defaultConsultationFee,
    this.isSurgical = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        specialityCode,
        name,
        description,
        imageUrl,
        icon,
        consultationDuration,
        defaultConsultationFee,
        isSurgical,
        isActive,
        createdAt,
        updatedAt,
      ];
}
