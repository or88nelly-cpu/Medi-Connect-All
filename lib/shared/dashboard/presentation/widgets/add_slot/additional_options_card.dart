import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class AdditionalOptionsCard extends StatefulWidget {
  final Function(bool isRecurring, String note)? onOptionsChanged;

  const AdditionalOptionsCard({super.key, this.onOptionsChanged});

  @override
  State<AdditionalOptionsCard> createState() => _AdditionalOptionsCardState();
}

class _AdditionalOptionsCardState extends State<AdditionalOptionsCard> {
  bool _isRecurring = false;
  String _noteText = "";

  void _showNoteDialog() {
    final controller = TextEditingController(text: _noteText);

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final dialogBg = isDark ? AppColors.terminalDarkCard : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;

        return AlertDialog(
          backgroundColor: dialogBg,
          title: Text(
            "Add Note",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Enter slot description / admin notes...",
              hintStyle: TextStyle(
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _noteText = controller.text;
                });
                _notifyChanges();
                Navigator.pop(ctx);
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }

  void _notifyChanges() {
    if (widget.onOptionsChanged != null) {
      widget.onOptionsChanged!(_isRecurring, _noteText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Additional Options",
            style: AppTextStyles.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          // Set as Recurring Slot
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18.sp,
                color: labelColor,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set as Recurring Slot",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      "Repeat this slot on multiple days",
                      style: TextStyle(color: labelColor, fontSize: 9.sp),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _isRecurring,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _isRecurring = val;
                  });
                  _notifyChanges();
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(color: borderColor, height: 1),
          ),
          // Add Note (Optional)
          InkWell(
            onTap: _showNoteDialog,
            child: Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 18.sp,
                  color: labelColor,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Note (Optional)",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                      Text(
                        _noteText.isEmpty
                            ? "Add a note for this slot"
                            : _noteText,
                        style: TextStyle(color: labelColor, fontSize: 9.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: labelColor, size: 18.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
