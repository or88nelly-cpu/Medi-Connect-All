import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/app_responsive.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/login_form.dart';

class AdminLoginPage extends StatefulWidget {
  final bool showBackButton;

  const AdminLoginPage({super.key, this.showBackButton = false});

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
    bool isDesktop = AppResponsive.isDesktop(context);
    return CustomScaffold(
      appBarNeeded: false,
      body: SingleChildScrollView(
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(
        vertical: 100.r,
        horizontal: 80.r,
      ).copyWith(bottom: 0.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _header(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Spacer(), personIcon(400.w)],
          ),
          _formData(),
        ],
      ),
    );
  }

  Widget personIcon(double width) {
    return CustomImageView(imagePath: AppAssets.ladyImagePng, width: width);
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60.r, vertical: 50.r),
      child: Column(
        children: [
          _header(),
          SizedBox(height: 20.h),

          Stack(
            children: [
              personIcon(200.w),
              Container(
                margin: EdgeInsets.only(top: 250.h),
                child: _formData(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formData() {
    return SizedBox(
      width:
          (AppResponsive.isDesktop(context)
                  ? MediaQuery.sizeOf(context).width * 0.3
                  : (MediaQuery.sizeOf(context).width * 0.7))
              .clamp(0, 360.w),
      child: LoginForm(
        onLoginPressed: () {},
        email: _usernameController,
        password: _passwordController,
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),

              decoration: BoxDecoration(
                color: AppColors.background(context),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: CustomImageView(
                imagePath: AppAssets.logoIconPng,
                width: 100.r,
                height: 100.r,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              children: [
                Text(
                  'MediConnect',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.adminPrimary,
                  ),
                ),
                Text(
                  'Multi speciality hospital',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
