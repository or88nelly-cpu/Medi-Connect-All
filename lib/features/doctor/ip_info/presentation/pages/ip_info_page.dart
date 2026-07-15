import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/entities/ip_occupancy_entity.dart';
import 'package:medi_connect/features/doctor/ip_info/presentation/bloc/ip_info_bloc.dart';
import 'package:medi_connect/features/doctor/ip_info/presentation/bloc/ip_info_event.dart';
import 'package:medi_connect/features/doctor/ip_info/presentation/bloc/ip_info_state.dart';

class IpInfoPage extends StatefulWidget {
  final DateTime? initialDate;
  const IpInfoPage({super.key, this.initialDate});

  @override
  State<IpInfoPage> createState() => _IpInfoPageState();
}

class _IpInfoPageState extends State<IpInfoPage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    context.read<IpInfoBloc>().add(LoadIpOccupancy());
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}\n${weekdays[date.weekday - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textCol, size: 20.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "IP Info",
          style: AppTextStyles.titleLarge.copyWith(color: textCol, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<IpInfoBloc, IpInfoState>(
        builder: (context, state) {
          if (state is IpInfoLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is IpInfoError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is IpInfoLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Date Navigation Banner
                  _buildDateBanner(isDark),
                  SizedBox(height: 16.h),

                  // 2. Hospital occupancy description text
                  Text(
                    "Overview of in-patient areas and their current occupancy",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // 3. Hospital Mockup Graphic Card
                  _buildHospitalGraphicCard(isDark),
                  SizedBox(height: 24.h),

                  // 4. Occupancy Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14.r,
                      crossAxisSpacing: 14.r,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: state.occupancyList.length,
                    itemBuilder: (context, idx) {
                      final item = state.occupancyList[idx];
                      return _buildOccupancyCard(item, cardBg, isDark);
                    },
                  ),
                  SizedBox(height: 14.h),

                  // 5. Custom Card
                  _buildCustomCard(cardBg, isDark),
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
        boxShadow: [
          BoxShadow(
            color: bg.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
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
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalGraphicCard(bool isDark) {
    return Container(
      width: double.infinity,
      height: 140.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 12.w,
            bottom: 0,
            top: 12.h,
            child: Icon(
              Icons.local_hospital_outlined,
              size: 110.r,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hospital Occupancy Status",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Review ward occupancy levels,\navailable beds, and operating lists.",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white60 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyCard(IpOccupancyEntity item, Color cardBg, bool isDark) {
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextCol = isDark ? Colors.white60 : Colors.grey[500];

    Color cardThemeColor = const Color(0xFF10B981); // ICU
    IconData icon = Icons.monitor_heart_outlined;
    if (item.name.toLowerCase() == 'ward') {
      cardThemeColor = const Color(0xFF3B82F6);
      icon = Icons.single_bed_outlined;
    } else if (item.name.toLowerCase() == 'room') {
      cardThemeColor = const Color(0xFFF59E0B);
      icon = Icons.door_front_door_outlined;
    } else if (item.name.toLowerCase().contains('surgery')) {
      cardThemeColor = const Color(0xFF8B5CF6);
      icon = Icons.calendar_month_outlined;
    } else if (item.name.toLowerCase() == 'block') {
      cardThemeColor = const Color(0xFFEF4444);
      icon = Icons.apartment_outlined;
    } else if (item.name.toLowerCase() == 'hdu') {
      cardThemeColor = const Color(0xFF06B6D4);
      icon = Icons.favorite_border_outlined;
    }

    final int pct = (item.occupiedPercentage * 100).toInt();

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: cardThemeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: cardThemeColor, size: 22.r),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: secondaryTextCol, size: 12.r),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            item.name,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: textCol,
            ),
          ),
          Text(
            "${item.occupiedBeds} Beds Occupied\nof ${item.totalBeds} Beds",
            style: AppTextStyles.bodySmall.copyWith(
              color: secondaryTextCol,
              fontSize: 10.sp,
            ),
          ),
          const Spacer(),
          // Sparkline visualization
          SizedBox(
            height: 24.h,
            width: double.infinity,
            child: CustomPaint(
              painter: SparklinePainter(item.sparkline, cardThemeColor),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$pct% Occupied",
                style: TextStyle(
                  color: cardThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
              Icon(Icons.trending_up, color: cardThemeColor, size: 12.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCard(Color cardBg, bool isDark) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.settings, color: Colors.grey),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Custom Area",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                  ),
                ),
                Text(
                  "Create and manage custom in-patient areas.",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white60 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            ),
            child: Text(
              "+ Create",
              style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final stepX = size.width / (data.length - 1);
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal == 0 ? 1.0 : maxVal - minVal;

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
