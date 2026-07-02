import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/widgets/speciality_form_dialog.dart';

class SpecialityListPage extends StatefulWidget {
  final String? initialQuery;

  const SpecialityListPage({super.key, this.initialQuery});

  @override
  State<SpecialityListPage> createState() => _SpecialityListPageState();
}

class _SpecialityListPageState extends State<SpecialityListPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
    if (widget.initialQuery != null) {
      _searchCtrl.text = widget.initialQuery!;
      _queryNotifier.value = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAdmin =
            authState is Authenticated && authState.user.role.value == 'admin';

        return CustomScaffold(
          customAppbar: CommonAppBar(
            title: "Hospital Specialties",
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<SpecialityBloc>().add(LoadSpecialities()),
              ),
            ],
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: () => SpecialityFormDialog.show(context),
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Add Speciality",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          body: Column(
            children: [
              // Search Header
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border(context)),
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    style: TextStyle(color: textColor),
                    onChanged: (val) => _queryNotifier.value = val,
                    decoration: InputDecoration(
                      hintText: "Search Specialties...",
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary(context),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
              ),

              // Specialties List
              Expanded(
                child: BlocConsumer<SpecialityBloc, SpecialityState>(
                  listener: (context, state) {
                    if (state is SpecialityActionSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is SpecialityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final list = state is SpecialitiesLoaded
                        ? state.specialities
                        : (state is SpecialityActionSuccess
                              ? state.updatedList
                              : []);

                    return ValueListenableBuilder<String>(
                      valueListenable: _queryNotifier,
                      builder: (context, query, _) {
                        final filtered = list.where((item) {
                          return item.name.toLowerCase().contains(
                                query.toLowerCase(),
                              ) ||
                              item.specialityCode.toLowerCase().contains(
                                query.toLowerCase(),
                              );
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_outlined,
                                  size: 64.r,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "No specialties found",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final spec = filtered[index];
                            return _buildSpecialityCard(
                              context,
                              spec,
                              isAdmin,
                              cardBg,
                              textColor,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecialityCard(
    BuildContext context,
    SpecialityEntity spec,
    bool isAdmin,
    Color cardBg,
    Color textColor,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageView(imagePath: spec.imageUrl ?? ""),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spec.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Code: ${spec.specialityCode}",
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 11.sp,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                if (isAdmin) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () => SpecialityFormDialog.show(
                      context,
                      existingSpeciality: spec,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: () => _confirmDelete(context, spec),
                  ),
                ],
              ],
            ),
            if (spec.description != null && spec.description!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                spec.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            const Divider(height: 1),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaInfo(
                  "Consultation Duration",
                  "${spec.consultationDuration} Mins",
                  context,
                ),
                _buildMetaInfo(
                  "Consultation Fee",
                  "\$${spec.defaultConsultationFee?.toStringAsFixed(2) ?? '0.00'}",
                  context,
                ),
                _buildMetaInfo(
                  "Type",
                  spec.isSurgical ? "Surgical" : "Clinical",
                  context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaInfo(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 9.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, SpecialityEntity spec) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Speciality"),
        content: Text(
          "Are you sure you want to delete ${spec.name}? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary(context)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SpecialityBloc>().add(
                DeleteSpecialityEvent(spec.id),
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
