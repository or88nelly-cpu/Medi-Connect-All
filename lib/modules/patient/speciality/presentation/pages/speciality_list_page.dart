import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/widgets/speciality_form_dialog.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/speciality_doctors_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';

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
          appBarNeeded: false, // Custom header instead
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
          bottomNavigationBar: PatientBottomNavBar(
            currentIndex: 0, // Home context
            onTap: (index) {
              if (index == 0) {
                context.go('/patient/dashboard');
              } else {
                // Navigate to other tabs on main dashboard
                context.go('/patient/dashboard');
                // You can schedule index select on next frame
              }
            },
          ),
          body: Column(
            children: [
              // ── 1. Mockup Header Banner with Shield ───────────────────
              _buildHeaderBanner(context, isDark),

              // ── 2. Search & Filter Bar ────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    // Search box
                    Expanded(
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.border(context)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey, size: 18.r),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                style: TextStyle(color: textColor, fontSize: 13.sp),
                                onChanged: (val) => _queryNotifier.value = val,
                                decoration: InputDecoration(
                                  hintText: "Search specialities...",
                                  hintStyle: TextStyle(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 12.sp,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Filter button
                    Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 18.r),
                          SizedBox(width: 6.w),
                          Text(
                            'Filter',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 3. Specialties 4-Column Grid ──────────────────────────
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

                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtered.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 12.h,
                                  childAspectRatio: 0.9,
                                ),
                                itemBuilder: (context, index) {
                                  final spec = filtered[index];
                                  final docCount = (spec.id.hashCode % 20) + 8; // Stable doc count
                                  return _buildGridCard(context, spec, docCount, isAdmin, isDark, cardBg, textColor);
                                },
                              ),
                              SizedBox(height: 20.h),
                              
                              // ── 4. Bottom Support Help Card ───────────────────
                              _buildSupportCard(context, isDark),
                              SizedBox(height: 32.h),
                            ],
                          ),
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

  Widget _buildHeaderBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: 190.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF131A2D), const Color(0xFF1F2B48)]
              : [const Color(0xFFE8F0FE), const Color(0xFFD2E3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Large floating Shield Graphic watermark
          Positioned(
            right: -20.w,
            bottom: -20.h,
            child: Opacity(
              opacity: isDark ? 0.08 : 0.15,
              child: Icon(
                Icons.health_and_safety_rounded,
                color: const Color(0xFF1A73E8),
                size: 180.r,
              ),
            ),
          ),
          
          // Back button and Text column
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Arrow Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primary,
                        size: 16.r,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Headings
                  Text(
                    'All Specialities',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24.sp,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Explore our wide range of medical specialities\nand find the best care for you.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? Colors.white60 : const Color(0xFF475569),
                      fontSize: 11.sp,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    SpecialityEntity spec,
    int docCount,
    bool isAdmin,
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            // Clickable Area
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => SpecialityDoctorsPage(speciality: spec),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dynamic specialty image
                    Container(
                      width: 50.r,
                      height: 50.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.r),
                        child: CustomImageView(
                          imagePath: spec.imageUrl ?? "",
                          width: 32.r,
                          height: 32.r,
                          color: isDark ? AppColors.lightBlueCard : null,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
                    // Name label
                    Text(
                      spec.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 10.5.sp,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Admin edit/delete buttons
            if (isAdmin)
              Positioned(
                top: 4,
                right: 4,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => SpecialityFormDialog.show(
                        context,
                        existingSpeciality: spec,
                      ),
                      child: Icon(Icons.edit, size: 14.r, color: AppColors.primary),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: () => _confirmDelete(context, spec),
                      child: Icon(Icons.delete, size: 14.r, color: AppColors.error),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFE8F0FE), const Color(0xFFCFE2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          // Decorative Folder Illustration
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.contact_support_outlined,
              color: AppColors.primary,
              size: 28.r,
            ),
          ),
          SizedBox(width: 14.w),

          // Text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Can't find what you need?",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Our care team is here to help you find the right specialist for your needs.",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white70 : const Color(0xFF4B5563),
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Contact button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support ticketing system coming soon!')),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1D4ED8),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Contact Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                    size: 12.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
