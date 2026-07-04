import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/department_colr_handler.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/modules/management/staff_management/data/models/department_model.dart';

class AdminDepartmentCard extends StatelessWidget {
  final DepartmentEntity department;

  const AdminDepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppResponsive.isMobile(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = AppDepartmentColorHandler.getStyle(department.name);

    final iconSize = isMobile ? 42.r : 62.r;
    final iconPadding = isMobile ? 3.r : 8.r;
    final verticalPadding = isMobile ? 6.h : 14.h;
    final fontSize = isMobile ? 9.sp : 12.sp;
    final radius = isMobile ? 16.r : 20.r;

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () {
        context.push(
          RouteNames.departmentDetail,
          extra: department is DepartmentModel
              ? department
              : DepartmentModel.fromEntity(department),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 8.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? .10 : .02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            const Spacer(),

            Container(
              width: iconSize,
              height: iconSize,
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(colors: style.gradient),
              ),
              child: CustomImageView(
                imagePath: department.imageUrl ?? "",
                color: Colors.white,
              ),
            ),

            const Spacer(),

            Text(
              department.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textDarkNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
