import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String id;
  final String hospitalId;
  final String imageUrl;
  final String linkType;
  final String? linkValue;
  final int displayOrder;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String targetRole;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BannerEntity({
    required this.id,
    required this.hospitalId,
    required this.imageUrl,
    required this.linkType,
    this.linkValue,
    required this.displayOrder,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.targetRole,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        hospitalId,
        imageUrl,
        linkType,
        linkValue,
        displayOrder,
        startDate,
        endDate,
        isActive,
        targetRole,
        createdBy,
        createdAt,
        updatedAt,
      ];
}
