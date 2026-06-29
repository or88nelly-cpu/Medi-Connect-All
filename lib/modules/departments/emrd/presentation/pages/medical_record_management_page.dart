import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_bottom_banner.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_list_item_card.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_record_details_sheet.dart';

class MedicalRecordManagementPage extends StatelessWidget {
  const MedicalRecordManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmrdBloc, EmrdState>(
      builder: (context, state) {
        if (state is EmrdLoading) {
          return const CustomScaffold(
            customAppbar: CommonAppBar(title: "Medical Record Management"),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is EmrdError) {
          return CustomScaffold(
            customAppbar: const CommonAppBar(
              title: "Medical Record Management",
            ),
            body: Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          );
        } else if (state is EmrdLoaded) {
          final filteredRecords = state.emrRecords
              .where((r) => r['specialty'] != 'Customer Care')
              .toList();

          return CustomScaffold(
            customAppbar: const CommonAppBar(
              title: "Medical Record Management",
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history_edu_outlined,
                        color: AppColors.primary,
                        size: 22.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Completed Consultations (EMR)",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${filteredRecords.length} Records",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (filteredRecords.isEmpty)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 32.h,
                          horizontal: 16.w,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                size: 48.r,
                                color: AppColors.textSecondary(
                                  context,
                                ).withValues(alpha: 0.4),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "No EMR Records Found",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Completed consultations will be recorded and listed here.",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = filteredRecords[index];
                        return EmrdListItemCard(
                          record: record,
                          onTap: () =>
                              showEmrdRecordDetailsSheet(context, record),
                        );
                      },
                    ),
                  SizedBox(height: 20.h),
                  EmrdBottomBanner(
                    onCreateEMR: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please complete a consultation from the Appointments page to generate a new EMR record.",
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const CustomScaffold(
          customAppbar: CommonAppBar(title: "Medical Record Management"),
          body: SizedBox.shrink(),
        );
      },
    );
  }
}
