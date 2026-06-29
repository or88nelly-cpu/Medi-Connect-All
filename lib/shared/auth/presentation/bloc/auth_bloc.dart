import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/get_current_user_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/login_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/logout_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/register_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// ==========================================
// Auth Bloc
// ==========================================
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc({
    required this._loginUseCase,
    required this._registerUseCase,
    required this._verifyOtpUseCase,
    required this._forgotPasswordUseCase,
    required this._resetPasswordUseCase,
    required this._logoutUseCase,
    required this._getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UserUpdated>(_onUserUpdated);
  }

  void _onUserUpdated(UserUpdated event, Emitter<AuthState> emit) {
    emit(Authenticated(event.user));
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold((failure) => emit(Unauthenticated()), (user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
        role: event.role,
        phoneNumber: event.phoneNumber,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onOtpVerificationRequested(
    OtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: event.email, token: event.token),
    );
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _forgotPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(
        Unauthenticated(),
      ), // Returns back to unauthenticated route / login state
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(event.newPassword);
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(Unauthenticated()),
    );
  }
}
