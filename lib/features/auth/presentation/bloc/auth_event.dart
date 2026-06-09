part of 'auth_bloc.dart';

// ==========================================
// Auth Events
// ==========================================
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;
  final String? phoneNumber;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, name, role, phoneNumber];
}

class OtpVerificationRequested extends AuthEvent {
  final String email;
  final String token;

  const OtpVerificationRequested({required this.email, required this.token});

  @override
  List<Object?> get props => [email, token];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String newPassword;

  const ResetPasswordRequested({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class LogoutRequested extends AuthEvent {}
