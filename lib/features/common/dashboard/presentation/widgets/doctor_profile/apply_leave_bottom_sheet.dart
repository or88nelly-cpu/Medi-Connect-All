import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class ApplyLeaveBottomSheet extends StatefulWidget {
  final Function(Map<String, String> leave)? onLeaveApplied;

  const ApplyLeaveBottomSheet({super.key, this.onLeaveApplied});

  @override
  State<ApplyLeaveBottomSheet> createState() => _ApplyLeaveBottomSheetState();
}

class _ApplyLeaveBottomSheetState extends State<ApplyLeaveBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedLeaveType;
  String _fromDate = "20 May 2025";
  String _toDate = "20 May 2025";
  String _selectedSession =
      "Full Day"; // Full Day, Morning Half, Afternoon Half
  String? _uploadedFileName;

  final List<String> _leaveTypes = [
    "Annual Leave",
    "Casual Leave",
    "Sick Leave",
    "Maternity Leave",
    "Paternity Leave",
  ];
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      setState(() {
        _charCount = _reasonController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2025, 5, 20),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      setState(() {
        if (isFrom) {
          _fromDate =
              "${picked.day} ${months[picked.month - 1]} ${picked.year}";
        } else {
          _toDate = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
        }
      });
    }
  }

  void _simulateUpload() {
    setState(() {
      _uploadedFileName = "supporting_doc_leave.pdf";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Document uploaded successfully!")),
    );
  }

  void _submit() {
    if (_selectedLeaveType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a leave type.")),
      );
      return;
    }
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a reason for leave.")),
      );
      return;
    }

    if (widget.onLeaveApplied != null) {
      widget.onLeaveApplied!({
        "type": _selectedLeaveType!,
        "range": _fromDate == _toDate ? _fromDate : "$_fromDate - $_toDate",
        "status": "Pending",
      });
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave request submitted successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : Colors.grey.shade300;
    final textColor = isDark ? AppColors.terminalDarkText : Colors.black87;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : Colors.grey.shade600;
    final fieldBg = isDark
        ? AppColors.terminalDarkFieldFill
        : Colors.grey.shade50;

    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle strip
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? borderColor : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // Header: Title and Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Apply for Leave",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: textColor, size: 20.sp),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(36.r, 36.r),
                  ),
                ),
              ],
            ),
            Divider(color: borderColor, height: 1),
            SizedBox(height: 14.h),

            // Form Content
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Type dropdown
                  Text(
                    "Leave Type*",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: fieldBg,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLeaveType,
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 14.sp,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Select Leave Type",
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        dropdownColor: cardBg,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: labelColor,
                          size: 16.sp,
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (val) =>
                            setState(() => _selectedLeaveType = val),
                        items: _leaveTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 14.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8.w),
                                Text(type),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Leave Date From / To
                  Text(
                    "Leave Date*",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      // From Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(true),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: fieldBg,
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "From Date",
                                      style: TextStyle(
                                        color: labelColor,
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      _fromDate,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 14.sp,
                                  color: labelColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 14.sp,
                          color: labelColor,
                        ),
                      ),
                      // To Date
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(false),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: fieldBg,
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "To Date",
                                      style: TextStyle(
                                        color: labelColor,
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      _toDate,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 14.sp,
                                  color: labelColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Session Toggles
                  Text(
                    "Session",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      _buildSessionButton(
                        "Full Day",
                        fieldBg,
                        borderColor,
                        labelColor,
                      ),
                      SizedBox(width: 4.w),
                      _buildSessionButton(
                        "Morning Half",
                        fieldBg,
                        borderColor,
                        labelColor,
                      ),
                      SizedBox(width: 4.w),
                      _buildSessionButton(
                        "Afternoon Half",
                        fieldBg,
                        borderColor,
                        labelColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Reason for Leave
                  Text(
                    "Reason for Leave*",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: fieldBg,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Icon(
                                Icons.description_outlined,
                                size: 14.sp,
                                color: labelColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextFormField(
                                controller: _reasonController,
                                maxLines: 3,
                                maxLength: 250,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 11.sp,
                                ),
                                buildCounter:
                                    (
                                      context, {
                                      required currentLength,
                                      required isFocused,
                                      maxLength,
                                    }) => null,
                                decoration: InputDecoration(
                                  hintText: "Enter reason for leave",
                                  hintStyle: TextStyle(
                                    color: labelColor,
                                    fontSize: 11.sp,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "$_charCount/250",
                          style: TextStyle(color: labelColor, fontSize: 9.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Contact Number
                  Text(
                    "Contact Number During Leave (Optional)",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: fieldBg,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: textColor, fontSize: 11.sp),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.phone_outlined,
                          size: 14.sp,
                          color: labelColor,
                        ),
                        hintText: "Enter contact number",
                        hintStyle: TextStyle(
                          color: labelColor,
                          fontSize: 11.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Supporting Document
                  Text(
                    "Supporting Document (Optional)",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: _simulateUpload,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                          style: BorderStyle
                              .solid, // Use simple solid borders if dash border is too complex, styled premium
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _uploadedFileName == null
                                ? Icons.cloud_upload_outlined
                                : Icons.check_circle_outline,
                            size: 20.sp,
                            color: _uploadedFileName == null
                                ? AppColors.primary
                                : Colors.green,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            _uploadedFileName ?? "Upload Document",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                          Text(
                            "PDF, JPG, PNG (Max. 5 MB)",
                            style: TextStyle(color: labelColor, fontSize: 9.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Form Submit / Cancel Actions
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Submit Leave Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionButton(
    String session,
    Color fieldBg,
    Color borderColor,
    Color labelColor,
  ) {
    final isSelected = _selectedSession == session;
    final activeBg = AppColors.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSession = session;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            border: Border.all(color: isSelected ? activeBg : borderColor),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(
              session,
              style: TextStyle(
                color: isSelected ? Colors.white : labelColor,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
