abstract class DoctorImageState {}

class DoctorImageInitial extends DoctorImageState {}

class DoctorImageLoading extends DoctorImageState {}

class DoctorImageLoaded extends DoctorImageState {
  final String? imageUrl;
  final String? gender;
  DoctorImageLoaded(this.imageUrl, this.gender);
}

class DoctorImageError extends DoctorImageState {}
