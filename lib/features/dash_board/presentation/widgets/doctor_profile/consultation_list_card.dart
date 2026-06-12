import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class ConsultationListCard extends StatefulWidget {
  const ConsultationListCard({super.key});

  @override
  State<ConsultationListCard> createState() => _ConsultationListCardState();
}

class _ConsultationListCardState extends State<ConsultationListCard> {
  String _selectedDate = "20 May 2025";
  String _selectedMode = "All"; // All, Video, Audio

  // Mock consultations data
  final List<Map<String, dynamic>> _consultations = [
    {
      "time": "09:00 AM",
      "name": "Ramesh Kumar",
      "age": 45,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Video",
      "status": "Completed"
    },
    {
      "time": "09:20 AM",
      "name": "Anita Sharma",
      "age": 38,
      "gender": "Female",
      "type": "New Consultation",
      "mode": "Audio",
      "status": "Completed"
    },
    {
      "time": "09:40 AM",
      "name": "Vikram Singh",
      "age": 52,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Video",
      "status": "Completed"
    },
    {
      "time": "10:00 AM",
      "name": "Pooja Mehta",
      "age": 29,
      "gender": "Female",
      "type": "New Consultation",
      "mode": "Video",
      "status": "Booked"
    },
    {
      "time": "10:20 AM",
      "name": "Arjun Patel",
      "age": 41,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Audio",
      "status": "Pending"
    },
    {
      "time": "10:40 AM",
      "name": "Suresh Yadav",
      "age": 50,
      "gender": "Male",
      "type": "New Consultation",
      "mode": "Video",
      "status": "Booked"
    },
    {
      "time": "11:00 AM",
      "name": "Neha Verma",
      "age": 35,
      "gender": "Female",
      "type": "Follow Up",
      "mode": "Audio",
      "status": "Pending"
    }
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF0F9F58);
      case "Booked":
        return AppColors.primary;
      case "Pending":
        return AppColors.warning;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    // Filter consultations based on selected mode
    final filteredConsultations = _consultations.where((item) {
      if (_selectedMode == "All") return true;
      return item["mode"].toString().toLowerCase() == _selectedMode.toLowerCase();
    }).toList();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with filters
          Row(
            children: [
              Expanded(
                child: Text(
                  "Consultation List",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              // Date picker
              Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDate,
                    dropdownColor: cardBg,
                    icon: Icon(Icons.arrow_drop_down, color: labelColor, size: 14.sp),
                    style: TextStyle(color: textColor, fontSize: 10.sp, fontWeight: FontWeight.w600),
                    onChanged: (val) => setState(() => _selectedDate = val!),
                    items: ["20 May 2025", "21 May 2025", "22 May 2025"].map((date) {
                      return DropdownMenuItem<String>(
                        value: date,
                        child: Text(date),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Video / Audio toggles
              _buildModeToggleButton("Video", Icons.videocam_outlined, AppColors.primary),
              SizedBox(width: 4.w),
              _buildModeToggleButton("Audio", Icons.phone_outlined, const Color(0xFF9C27B0)),
            ],
          ),
          SizedBox(height: 16.h),
          // Consultation table / headers
          Row(
            children: [
              Expanded(flex: 2, child: Text("Time", style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.bold))),
              Expanded(flex: 4, child: Text("Patient Name", style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.bold))),
              Expanded(flex: 3, child: Text("Type", style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("Mode", style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Status", style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 1, child: Container()),
            ],
          ),
          Divider(color: borderColor),
          // Rows
          filteredConsultations.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: Text("No consultations found for selected mode.", style: TextStyle(color: labelColor, fontSize: 12.sp)),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredConsultations.length,
                  separatorBuilder: (context, idx) => Divider(color: borderColor, height: 1),
                  itemBuilder: (context, idx) {
                    final item = filteredConsultations[idx];
                    final isVideo = item["mode"] == "Video";
                    final statusColor = _getStatusColor(item["status"]);
                    final avatarUrl = "https://ui-avatars.com/api/?name=${Uri.encodeComponent(item["name"])}&background=random";

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          // Time
                          Expanded(
                            flex: 2,
                            child: Text(
                              item["time"],
                              style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 11.sp),
                            ),
                          ),
                          // Patient Info
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 12.r,
                                  backgroundImage: NetworkImage(avatarUrl),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item["name"],
                                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.sp),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${item["age"]} Years, ${item["gender"]}",
                                        style: TextStyle(color: labelColor, fontSize: 9.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Type
                          Expanded(
                            flex: 3,
                            child: Text(
                              item["type"],
                              style: TextStyle(color: labelColor, fontSize: 11.sp),
                            ),
                          ),
                          // Mode
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Icon(
                                isVideo ? Icons.videocam : Icons.phone,
                                size: 14.sp,
                                color: isVideo ? AppColors.primary : const Color(0xFF9C27B0),
                              ),
                            ),
                          ),
                          // Status
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: statusColor, width: 0.5),
                                ),
                                child: Text(
                                  item["status"],
                                  style: TextStyle(color: statusColor, fontSize: 9.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          // Action button
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.more_horiz, color: labelColor, size: 14.sp),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Action clicked for ${item["name"]}")),
                                );
                              },
                              style: IconButton.styleFrom(padding: EdgeInsets.zero, ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          Divider(color: borderColor),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total ${filteredConsultations.length} consultations",
                style: TextStyle(color: labelColor, fontSize: 10.sp, fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening consultation report details...")),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(color: AppColors.primary, fontSize: 11.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggleButton(String mode, IconData icon, Color color) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = isSelected ? "All" : mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(color: isSelected ? color : AppColors.terminalDarkBorder.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12.sp, color: isSelected ? Colors.white : color),
            SizedBox(width: 4.w),
            Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
