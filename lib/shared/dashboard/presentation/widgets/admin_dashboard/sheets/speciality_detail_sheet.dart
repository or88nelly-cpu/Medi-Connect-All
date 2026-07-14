import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';

class SpecialityDetailSheet extends StatefulWidget {
  final SpecialityEntity speciality;

  const SpecialityDetailSheet({super.key, required this.speciality});

  static Future<void> show(
    BuildContext context,
    SpecialityEntity speciality,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpecialityDetailSheet(speciality: speciality),
    );
  }

  @override
  State<SpecialityDetailSheet> createState() => _SpecialityDetailSheetState();
}

class _SpecialityDetailSheetState extends State<SpecialityDetailSheet> {
  bool _loading = true;
  List<Map<String, dynamic>> _doctors = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      // Fetch doctors in this speciality via: doctors → employees → users
      final response = await Supabase.instance.client
          .from('doctors')
          .select('*, employees(*, users(*))')
          .eq('speciality_id', widget.speciality.id)
          .eq('is_active', true);

      final list = (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      if (mounted) {
        setState(() {
          _doctors = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load doctors';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;

    const palette = [
      Color(0xFFEF4444), Color(0xFFA855F7), Color(0xFF3B82F6),
      Color(0xFFEC4899), Color(0xFF14B8A6), Color(0xFFEAB308),
      Color(0xFF22C55E), Color(0xFF06B6D4), Color(0xFFF97316), Color(0xFF8B5CF6),
    ];
    int hash = 0;
    for (int i = 0; i < widget.speciality.name.length; i++) {
      hash = widget.speciality.name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final iconColor = palette[hash.abs() % palette.length];

    return Container(
      height: screenH * 0.78,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header card
          Container(
            margin: EdgeInsets.all(20.r),
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.12),
                  iconColor.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: iconColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.speciality.imageUrl != null &&
                            widget.speciality.imageUrl!.isNotEmpty
                        ? CustomImageView(
                            imagePath: widget.speciality.imageUrl!,
                            width: 32.r,
                            height: 32.r,
                            color: iconColor,
                            fit: BoxFit.contain,
                          )
                        : Icon(Icons.medical_services, color: iconColor, size: 30.sp),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.speciality.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.dashboardTextPrimary(context),
                        ),
                      ),
                      if (widget.speciality.description != null &&
                          widget.speciality.description!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          widget.speciality.description!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.dashboardTextPrimary(context)
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 6.w,
                        children: [
                          if (widget.speciality.isSurgical)
                            _Chip(
                              label: 'Surgical',
                              color: Colors.red,
                            ),
                          _Chip(
                            label: '${widget.speciality.consultationDuration} min',
                            color: iconColor,
                          ),
                          if (widget.speciality.defaultConsultationFee != null)
                            _Chip(
                              label: '₹${widget.speciality.defaultConsultationFee!.toStringAsFixed(0)}',
                              color: Colors.green,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Doctors section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.person_search_outlined, size: 18.sp, color: iconColor),
                SizedBox(width: 8.w),
                Text(
                  'Available Doctors',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.dashboardTextPrimary(context),
                  ),
                ),
                const Spacer(),
                if (!_loading)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_doctors.length} doctors',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Doctors List
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: iconColor))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off_outlined, size: 40.sp, color: Colors.grey),
                            SizedBox(height: 8.h),
                            Text(_error!, style: AppTextStyles.labelMedium.copyWith(color: Colors.grey)),
                          ],
                        ),
                      )
                    : _doctors.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_off_outlined, size: 48.sp, color: Colors.grey),
                                SizedBox(height: 8.h),
                                Text('No doctors assigned yet',
                                    style: AppTextStyles.labelMedium.copyWith(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: _doctors.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                            itemBuilder: (context, index) {
                              final doc = _doctors[index];
                              final emp = doc['employees'] as Map<String, dynamic>?;
                              final user = emp?['users'] as Map<String, dynamic>?;
                              final firstName = (user?['first_name'] as String? ?? '').trim();
                              final lastName = (user?['last_name'] as String? ?? '').trim();
                              final name = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
                              final photo = user?['profile_photo'] as String?;
                              final qualification = doc['qualification'] as String?;
                              final expYears = doc['experience_years'] as int? ?? 0;
                              final fee = (doc['consultation_fee'] as num?)?.toDouble() ?? 0;
                              final isAvailable = doc['is_available'] as bool? ?? false;

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                                leading: CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor: iconColor.withValues(alpha: 0.1),
                                  backgroundImage: photo != null && photo.isNotEmpty
                                      ? NetworkImage(photo)
                                      : null,
                                  child: photo == null || photo.isEmpty
                                      ? Text(
                                          name.isNotEmpty ? name[0].toUpperCase() : 'D',
                                          style: TextStyle(
                                            color: iconColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  name.isNotEmpty ? 'Dr. $name' : 'Unknown',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.dashboardTextPrimary(context),
                                  ),
                                ),
                                subtitle: Text(
                                  [
                                    if (qualification != null && qualification.isNotEmpty) qualification,
                                    if (expYears > 0) '$expYears yrs exp',
                                    'Fee: ₹${fee.toStringAsFixed(0)}',
                                  ].join(' • '),
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.dashboardTextPrimary(context).withValues(alpha: 0.5),
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: isAvailable
                                        ? Colors.green.withValues(alpha: 0.12)
                                        : Colors.orange.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    isAvailable ? 'Available' : 'Busy',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: isAvailable ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
