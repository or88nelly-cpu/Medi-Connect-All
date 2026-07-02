import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PatientChatTab extends StatefulWidget {
  const PatientChatTab({super.key});

  @override
  State<PatientChatTab> createState() => _PatientChatTabState();
}

class _PatientChatTabState extends State<PatientChatTab> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _chatThreads = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchChatThreads();
  }

  Future<void> _fetchChatThreads() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Query patient's appointments to get the doctors they can chat with
      final response = await Supabase.instance.client
          .from('appointments')
          .select()
          .eq('patient_id', authState.user.id);

      final appointments = List<Map<String, dynamic>>.from(response);
      
      // Group by doctor_id/doctor_name to create unique chat threads
      final Map<String, Map<String, dynamic>> grouped = {};
      for (final apt in appointments) {
        final docId = apt['doctor_id'] ?? '';
        final docName = apt['doctor_name'] ?? 'Doctor';
        final specialty = apt['specialty'] ?? 'General';
        
        if (docId.isNotEmpty && !grouped.containsKey(docId)) {
          grouped[docId] = {
            'doctor_id': docId,
            'doctor_name': docName,
            'specialty': specialty,
            'last_message': 'No messages yet. Tap to start chat.',
            'time': 'Active',
          };
        }
      }

      setState(() {
        _chatThreads = grouped.values.toList();
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
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.chat,
            style: AppTextStyles.headingMedium.copyWith(
              fontSize: 22.sp,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
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
              "Failed to load chats",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            TextButton(
              onPressed: _fetchChatThreads,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (_chatThreads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              color: AppColors.textSecondary(context).withValues(alpha: 0.5),
              size: 48.r,
            ),
            SizedBox(height: 12.h),
            Text(
              "No active chats. Book an appointment to chat with a doctor.",
              textAlign: TextAlign.center,
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
      itemCount: _chatThreads.length,
      itemBuilder: (context, idx) {
        final thread = _chatThreads[idx];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: AppColors.border(context)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.r),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(
                alpha: 0.1,
              ),
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  thread['doctor_name']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                Text(
                  thread['time']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  thread['specialty']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  thread['last_message']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary(context).withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Chat room with ${thread['doctor_name']} is opening..."),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
