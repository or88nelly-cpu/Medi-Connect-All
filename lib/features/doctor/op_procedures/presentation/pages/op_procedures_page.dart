import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctor/op_procedures/presentation/bloc/op_procedures_bloc.dart';
import 'package:medi_connect/features/doctor/op_procedures/presentation/bloc/op_procedures_event.dart';
import 'package:medi_connect/features/doctor/op_procedures/presentation/bloc/op_procedures_state.dart';

class OpProceduresPage extends StatefulWidget {
  final DateTime? initialDate;
  const OpProceduresPage({super.key, this.initialDate});

  @override
  State<OpProceduresPage> createState() => _OpProceduresPageState();
}

class _OpProceduresPageState extends State<OpProceduresPage> {
  late DateTime _selectedDate;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    context.read<OpProceduresBloc>().add(LoadOpProcedures());
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}\n${weekdays[date.weekday - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final authState = context.read<AuthBloc>().state;
    final doctor = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textCol,
            size: 20.r,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "OP Procedures",
          style: AppTextStyles.titleLarge.copyWith(
            color: textCol,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<OpProceduresBloc, OpProceduresState>(
        builder: (context, state) {
          if (state is OpProceduresLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is OpProceduresError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.red),
              ),
            );
          }
          if (state is OpProceduresLoaded) {
            final filteredList = state.procedures.where((p) {
              return p.patientName.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  p.patientId.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
            }).toList();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Date Navigation Banner
                  _buildDateBanner(isDark),
                  SizedBox(height: 16.h),

                  // 2. Doctor profile info banner card
                  if (doctor != null) _buildDoctorBanner(doctor, isDark),
                  SizedBox(height: 24.h),

                  // 3. Today's Procedure Summary Title
                  Text(
                    "Today's Procedure Summary",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textCol,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 4. Summaries Grid
                  _buildSummaryGrid(isDark),
                  SizedBox(height: 24.h),

                  // 5. Quick Actions Title
                  Text(
                    "Quick Action",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textCol,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // 6. Quick Actions Grid
                  _buildQuickActions(isDark),
                  SizedBox(height: 24.h),

                  // 7. Search and Filter row
                  _buildFiltersRow(isDark, cardBg),
                  SizedBox(height: 16.h),

                  // 8. Patients List Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's OP Patients (${filteredList.length})",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: textCol,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: isDark ? Colors.white54 : Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  filteredList.isEmpty
                      ? Container(
                          height: 100.h,
                          alignment: Alignment.center,
                          child: Text(
                            "No patients found matching search criteria.",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, idx) {
                            final item = filteredList[idx];
                            return _buildPatientCard(item, cardBg, isDark);
                          },
                        ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDateBanner(bool isDark) {
    final bg = isDark ? const Color(0xFF1E293B) : const Color(0xFF0F6FFF);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {},
          ),
          Text(
            _formatDate(_selectedDate),
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorBanner(dynamic doctor, bool isDark) {
    final titleCol = isDark ? Colors.white : AppColors.textDarkNavy;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundImage: ProfileImageHelper.getAvatarImage(
              doctor.profilePhoto,
              'doctor',
              doctor.gender,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.fullName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleCol,
                  ),
                ),
                Text(
                  "MBBS, MD - General Medicine",
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                ),
                Text(
                  "General Medicine  •  Reg. No: KMC-65432",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "Available",
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid(bool isDark) {
    final list = [
      {
        'title': 'Total Procedures',
        'count': '24',
        'color': AppColors.primary,
        'icon': Icons.assignment_outlined,
      },
      {
        'title': 'Completed',
        'count': '10',
        'color': AppColors.success,
        'icon': Icons.check_circle_outline,
      },
      {
        'title': 'Scheduled',
        'count': '6',
        'color': AppColors.warning,
        'icon': Icons.calendar_today_outlined,
      },
      {
        'title': 'In Progress',
        'count': '4',
        'color': AppColors.purple,
        'icon': Icons.hourglass_empty_outlined,
      },
      {
        'title': 'Cancelled',
        'count': '2',
        'color': AppColors.error,
        'icon': Icons.cancel_outlined,
      },
      {
        'title': 'Follow-up',
        'count': '5',
        'color': AppColors.info,
        'icon': Icons.sync_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.r,
        crossAxisSpacing: 10.r,
        childAspectRatio: 1.0,
      ),
      itemCount: list.length,
      itemBuilder: (context, idx) {
        final item = list[idx];
        final color = item['color'] as Color;
        return Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(item['icon'] as IconData, color: color, size: 20.r),
              Text(
                item['count'] as String,
                style: AppTextStyles.headingMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.textDarkNavy,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey,
                  fontSize: 8.5.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(bool isDark) {
    final actions = [
      {
        'title': 'Upload Consent',
        'color': const Color(0xFF0EA5E9),
        'icon': Icons.file_upload_outlined,
      },
      {
        'title': 'Add Notes',
        'color': const Color(0xFF8B5CF6),
        'icon': Icons.note_add_outlined,
      },
      {
        'title': 'Prescribe Med',
        'color': const Color(0xFF10B981),
        'icon': Icons.medication_outlined,
      },
      {
        'title': 'Schedule Visit',
        'color': AppColors.warning,
        'icon': Icons.calendar_month_outlined,
      },
      {
        'title': 'Print Report',
        'color': AppColors.info,
        'icon': Icons.print_outlined,
      },
      {
        'title': 'Generate Bill',
        'color': const Color(0xFFEC4899),
        'icon': Icons.receipt_long_outlined,
      },
      {
        'title': 'Download Forms',
        'color': const Color(0xFF6366F1),
        'icon': Icons.file_download_outlined,
      },
      {
        'title': 'Create Form',
        'color': const Color(0xFF06B6D4),
        'icon': Icons.add_to_photos_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10.r,
        crossAxisSpacing: 10.r,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, idx) {
        final item = actions[idx];
        final col = item['color'] as Color;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'] as IconData, color: col, size: 24.r),
                    SizedBox(height: 6.h),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 8.5.sp,
                        color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFiltersRow(bool isDark, Color cardBg) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 16.r),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.textDarkNavy,
                      fontSize: 11.sp,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Search patient name or ID...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey[200]!,
            ),
          ),
          child: Icon(
            Icons.tune,
            color: isDark ? Colors.white70 : AppColors.textDarkNavy,
            size: 18.r,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientCard(OpProcedureEntity item, Color cardBg, bool isDark) {
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextCol = isDark ? Colors.white60 : Colors.grey[500];

    Color statusColor = const Color(0xFF10B981);
    if (item.status.toLowerCase() == 'in progress') {
      statusColor = const Color(0xFF8B5CF6);
    } else if (item.status.toLowerCase() == 'scheduled') {
      statusColor = AppColors.warning;
    } else if (item.status.toLowerCase() == 'cancelled') {
      statusColor = AppColors.error;
    }

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Token, Name, Profile Photo, Details
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  "Token ${item.tokenNumber}",
                  style: TextStyle(
                    color: textCol,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: item.priority.toLowerCase() == 'high'
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item.priority,
                  style: TextStyle(
                    color: item.priority.toLowerCase() == 'high'
                        ? AppColors.error
                        : const Color(0xFFD97706),
                    fontWeight: FontWeight.bold,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: ProfileImageHelper.getAvatarImage(
                  item.profilePhoto,
                  'patient',
                  item.gender,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.patientName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textCol,
                        fontSize: 13.sp,
                      ),
                    ),
                    Text(
                      "PID: ${item.patientId}  •  ${item.age} Yrs  •  ${item.gender}",
                      style: TextStyle(color: secondaryTextCol, fontSize: 9.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 20.h,
            color: isDark ? Colors.white10 : Colors.grey[200],
          ),
          // Row 2: Diagnosis & Procedure
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Procedure & Diagnosis",
                    style: TextStyle(color: secondaryTextCol, fontSize: 8.5.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${item.procedure} (${item.diagnosis})",
                    style: TextStyle(
                      color: textCol,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Appointment Time",
                    style: TextStyle(color: secondaryTextCol, fontSize: 8.5.sp),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${item.time} | ${item.date}",
                    style: TextStyle(
                      color: textCol,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 20.h,
            color: isDark ? Colors.white10 : Colors.grey[200],
          ),
          // Row 3: Status & Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    item.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "₹${item.paymentAmount} (${item.paymentStatus})",
                    style: TextStyle(
                      color: item.paymentStatus.toLowerCase() == 'paid'
                          ? AppColors.green
                          : AppColors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      item.status.toLowerCase() == 'completed'
                          ? "View"
                          : (item.status.toLowerCase() == 'in progress'
                                ? "Resume"
                                : "Start"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
