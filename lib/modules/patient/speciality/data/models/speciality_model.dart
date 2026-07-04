import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';

class SpecialityModel extends SpecialityEntity {
  const SpecialityModel({
    required super.id,
    required super.specialityCode,
    required super.name,
    super.description,
    super.imageUrl,
    super.icon,
    super.consultationDuration,
    super.defaultConsultationFee,
    super.isSurgical,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      id: json['id'] as String,
      specialityCode: json['speciality_code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      icon: json['icon'] as String?,
      consultationDuration: json['consultation_duration'] as int? ?? 15,
      defaultConsultationFee: json['default_consultation_fee'] != null
          ? (json['default_consultation_fee'] as num).toDouble()
          : null,
      isSurgical: json['is_surgical'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciality_code': specialityCode,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'icon': icon,
      'consultation_duration': consultationDuration,
      'default_consultation_fee': defaultConsultationFee,
      'is_surgical': isSurgical,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory SpecialityModel.fromEntity(SpecialityEntity entity) {
    return SpecialityModel(
      id: entity.id,
      specialityCode: entity.specialityCode,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      icon: entity.icon,
      consultationDuration: entity.consultationDuration,
      defaultConsultationFee: entity.defaultConsultationFee,
      isSurgical: entity.isSurgical,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  SpecialityModel copyWith({
    String? id,
    String? specialityCode,
    String? name,
    String? description,
    String? imageUrl,
    String? icon,
    int? consultationDuration,
    double? defaultConsultationFee,
    bool? isSurgical,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpecialityModel(
      id: id ?? this.id,
      specialityCode: specialityCode ?? this.specialityCode,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      consultationDuration: consultationDuration ?? this.consultationDuration,
      defaultConsultationFee:
          defaultConsultationFee ?? this.defaultConsultationFee,
      isSurgical: isSurgical ?? this.isSurgical,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
