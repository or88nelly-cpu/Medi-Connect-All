abstract class DoctorImageEvent {}

class LoadDoctorImage extends DoctorImageEvent {
  final String doctorId;
  LoadDoctorImage(this.doctorId);
}
