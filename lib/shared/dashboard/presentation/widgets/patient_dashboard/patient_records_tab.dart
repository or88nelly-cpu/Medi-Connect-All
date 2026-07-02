import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PatientRecordsTab extends StatefulWidget {
  const PatientRecordsTab({super.key});

  @override
  State<PatientRecordsTab> createState() => _PatientRecordsTabState();
}

class _PatientRecordsTabState extends State<PatientRecordsTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _records = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('emr_records')
          .select()
          .eq('patient_id', authState.user.id)
          .order('recorded_at', ascending: false);

      setState(() {
        _records = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.medicalRecords,
            style: AppTextStyles.headingMedium.copyWith(
              fontSize: 22.sp,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _buildBody(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40.r),
            SizedBox(height: 8.h),
            Text(
              "Failed to load records",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: _fetchRecords,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              color: AppColors.textSecondary(context).withValues(alpha: 0.5),
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              "No medical records found.",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _records.length,
      itemBuilder: (context, idx) {
        final rec = _records[idx];
        final specialty = rec['specialty'] ?? 'General';
        final doctor = rec['doctor_name'] ?? 'Doctor';
        final dateStr = rec['recorded_at'] != null
            ? _formatDate(DateTime.parse(rec['recorded_at']))
            : 'Date Not Set';
        
        final hasLab = (rec['lab_tests'] ?? '').toString().isNotEmpty;

        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.border(context)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.r),
            leading: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: (hasLab ? AppColors.secondary : AppColors.accent)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasLab ? Icons.science_outlined : Icons.description_outlined,
                color: hasLab ? AppColors.secondary : AppColors.accent,
              ),
            ),
            title: Text(
              "$specialty Consultation Report",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            subtitle: Text(
              "Doctor: $doctor \nDate: $dateStr",
            ),
            trailing: const Icon(Icons.download_outlined),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
