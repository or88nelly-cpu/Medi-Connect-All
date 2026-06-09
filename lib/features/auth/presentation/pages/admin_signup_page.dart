import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/admin_header.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/signup_footer.dart';
import 'package:medi_connect/features/auth/presentation/widgets/signup_form.dart';

class AdminSignUpPage extends StatefulWidget {
  final bool showBackButton;

  const AdminSignUpPage({super.key, this.showBackButton = true});

  @override
  State<AdminSignUpPage> createState() => _AdminSignUpPageState();
}

class _AdminSignUpPageState extends State<AdminSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Use ValueNotifier for local, widget-only state — no setState for page state.
  final _isAgreedNotifier = ValueNotifier<bool>(false);
  final _selectedRoleNotifier = ValueNotifier<String>('admin');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(
            RouteNames.otpVerification,
            extra: _emailController.text.trim(),
          );
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(message: state.failure.message),
          );
        }
      },
      child: _contents(),
    );
  }

  Widget _contents() {
    return CustomScaffold(
      appBarNeeded: widget.showBackButton,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20.r,
          vertical: 50.r,
        ).copyWith(bottom: 20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AdminHeader(),
              SizedBox(height: 12.r),
              // ValueListenableBuilder drives role & agreement state — no setState.
              ValueListenableBuilder<String>(
                valueListenable: _selectedRoleNotifier,
                builder: (context, selectedRole, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isAgreedNotifier,
                    builder: (context, isAgreed, _) {
                      return SignUpForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isAgreed: isAgreed,
                        selectedRole: selectedRole,
                        onRoleChanged: (role) =>
                            _selectedRoleNotifier.value = role,
                        onAgreedChanged: (val) => _isAgreedNotifier.value = val,
                        onRegisterPressed: _onRegisterPressed,
                      );
                    },
                  );
                },
              ),
              const SignUpFooter(),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    if (!_isAgreedNotifier.value) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          message:
              "Please agree to the Terms of Service & Privacy Policy to continue.",
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (_) =>
              const ErrorDialog(message: AppStrings.passwordMismatch),
        );
        return;
      }

      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          role: _selectedRoleNotifier.value,
          phoneNumber: _phoneController.text.isNotEmpty
              ? _phoneController.text.trim()
              : null,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isAgreedNotifier.dispose();
    _selectedRoleNotifier.dispose();
    super.dispose();
  }
}
