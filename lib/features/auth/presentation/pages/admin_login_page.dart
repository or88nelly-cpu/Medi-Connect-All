
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/admin_header.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/login_footer.dart';
import 'package:medi_connect/features/auth/presentation/widgets/login_form.dart';

class AdminLoginPage extends StatefulWidget {
  final bool showBackButton;

  const AdminLoginPage({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final role = state.user.role;
          context.go('/$role/dashboard');
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
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 50.r)
            .copyWith(bottom: 20.r),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AdminHeader(),
                SizedBox(height: 12.r),
                LoginForm(
                  email: _usernameController,
                  password: _passwordController,
                  onLoginPressed: _onLoginPressed,
                ),
                LoginFooter()
              ],
            )),
      ),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
