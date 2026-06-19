import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/modules/departments/cssd/presentation/bloc/cssd_bloc.dart';

class CssdDetailPage extends StatefulWidget {
  const CssdDetailPage({super.key});

  @override
  State<CssdDetailPage> createState() => _CssdDetailPageState();
}

class _CssdDetailPageState extends State<CssdDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<CssdBloc>()..add(LoadCssdStats()),
      child: CustomScaffold(
        customAppbar: const CommonAppBar(title: "CSSD Department"),
        body: BlocBuilder<CssdBloc, CssdState>(
          builder: (context, state) {
            if (state is CssdLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CssdError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              );
            } else if (state is CssdLoaded) {
              final stats = state.stats;
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Operational Insights",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final key = stats.keys.elementAt(index);
                        final val = stats[key];
                        final displayKey = key
                            .split('_')
                            .map((word) {
                              if (word == 'pct') return '%';
                              if (word == 'min' || word == 'mins') {
                                return 'Mins';
                              }
                              return word[0].toUpperCase() + word.substring(1);
                            })
                            .join(' ');

                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(color: AppColors.border(context)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayKey,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  val.toString(),
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
