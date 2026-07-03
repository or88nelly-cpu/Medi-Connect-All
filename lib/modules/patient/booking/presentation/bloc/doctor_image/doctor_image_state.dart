abstract class DoctorImageState {}

class DoctorImageInitial extends DoctorImageState {}

class DoctorImageLoading extends DoctorImageState {}

class DoctorImageLoaded extends DoctorImageState {
  final String? imageUrl;
  DoctorImageLoaded(this.imageUrl);
}

class DoctorImageError extends DoctorImageState {}
