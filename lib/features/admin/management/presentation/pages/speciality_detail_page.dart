import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/features/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/core/utils/dashboard_color_palette.dart';
import 'package:medi_connect/features/admin/management/presentation/widgets/speciality_detail/speciality_info_card.dart';
import 'package:medi_connect/features/admin/management/presentation/widgets/speciality_detail/speciality_doctor_list_item.dart';

class SpecialityDetailPage extends StatefulWidget {
  final SpecialityEntity speciality;

  const SpecialityDetailPage({super.key, required this.speciality});

  @override
  State<SpecialityDetailPage> createState() => _SpecialityDetailPageState();
}

class _SpecialityDetailPageState extends State<SpecialityDetailPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _filteredDoctors = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
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
          _filteredDoctors = list;
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

  void _filterDoctors(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors = _doctors.where((doc) {
          final emp = doc['employees'] as Map<String, dynamic>?;
          final user = emp?['users'] as Map<String, dynamic>?;
          final firstName = (user?['first_name'] as String? ?? '').trim();
          final lastName = (user?['last_name'] as String? ?? '').trim();
          final name = '$firstName $lastName'.toLowerCase();
          final qualification = (doc['qualification'] as String? ?? '')
              .toLowerCase();

          return name.contains(query.toLowerCase()) ||
              qualification.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = DashboardColorPalette.forName(widget.speciality.name);

    return CustomScaffold(
      customAppbar: CommonAppBar(title: widget.speciality.name),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpecialityInfoCard(speciality: widget.speciality),
              SizedBox(height: 24.h),
              Text(
                'Available Doctors',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                onChanged: _filterDoctors,
                decoration: InputDecoration(
                  hintText: 'Search doctors by name or qualification...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border(context)),
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.surface : Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else if (_filteredDoctors.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.h),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_off_outlined,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'No doctors found matching the criteria',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredDoctors.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 20.h,
                    color: isDark ? Colors.white10 : Colors.black12,
                  ),
                  itemBuilder: (context, index) {
                    return SpecialityDoctorListItem(
                      doctor: _filteredDoctors[index],
                      iconColor: iconColor,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
