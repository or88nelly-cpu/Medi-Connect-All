import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/registration/id_card_preview.dart';

class PatientRegistrationRecordDetailPage extends StatefulWidget {
  final Map<String, dynamic> record;
  final Future<Map<String, dynamic>?> Function(String)? onFetchPatientDetails;
  final Future<void> Function(Map<String, dynamic>, String)? onConfirmPayment;

  const PatientRegistrationRecordDetailPage({
    super.key,
    required this.record,
    this.onFetchPatientDetails,
    this.onConfirmPayment,
  });

  @override
  State<PatientRegistrationRecordDetailPage> createState() =>
      _PatientRegistrationRecordDetailPageState();
}

class _PatientRegistrationRecordDetailPageState
    extends State<PatientRegistrationRecordDetailPage> {
  late String _paymentStatus;
  late String _payMethod;
  bool _isPaying = false;
  String _idCardTab = 'Front';
  late Future<Map<String, dynamic>?> _patientDetailsFuture;

  @override
  void initState() {
    super.initState();
    _paymentStatus = widget.record['registration_payment_status'] ?? 'Pending';
    _payMethod = widget.record['payment_method'] ?? 'Cash';
    _patientDetailsFuture = _fetchPatientDetails(widget.record['patient_id']);
  }

  Future<Map<String, dynamic>?> _fetchPatientDetails(String patientUuid) async {
    if (widget.onFetchPatientDetails != null) {
      return widget.onFetchPatientDetails!(patientUuid);
    }
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      final response = await supabase
          .from('users')
          .select()
          .eq('id', patientUuid)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint("Failed to fetch patient details in EMRD: $e");
      return null;
    }
  }

  Future<void> _confirmRegistrationPayment(
    Map<String, dynamic> record,
    String payMethod,
  ) async {
    if (widget.onConfirmPayment != null) {
      return widget.onConfirmPayment!(record, payMethod);
    }
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      await supabase
          .from('emr_records')
          .update({
            'registration_payment_status': 'Paid',
            'payment_method': payMethod == 'Online' ? 'UPI/QR' : 'Cash',
          })
          .eq('patient_id', record['patient_id']);
    } catch (e) {
      debugPrint("Failed to update registration payment in Supabase: $e");
    }

    try {
      final storage = GetIt.I<SecureStorageService>();
      final localDataStr = await storage.read('emr_records');
      if (localDataStr != null) {
        final List<dynamic> list = jsonDecode(localDataStr);
        for (final item in list) {
          if (item['patient_id'] == record['patient_id'] &&
              item['specialty'] == 'Customer Care') {
            item['registration_payment_status'] = 'Paid';
            item['payment_method'] = payMethod == 'Online' ? 'UPI/QR' : 'Cash';
          }
        }
        await storage.write('emr_records', jsonEncode(list));
      }
    } catch (e) {
      debugPrint("Failed to update registration payment in local storage: $e");
    }
  }

  void _showPaymentSuccessDialog(
    BuildContext context,
    String patientName,
    String uhid,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09121F)
            : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: 10.w),
            Text(
              "Payment Confirmed",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Registration payment of ₹200.00 has been successfully processed for $patientName.",
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: 12.h),
            Text(
              "UHID: $uhid",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "The patient ID card is now active and ready for download/print.",
              style: AppTextStyles.bodySmall.copyWith(color: Colors.green),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _simulatePrint(String name, String uhid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09121F)
            : Colors.white,
        title: Row(
          children: [
            Icon(Icons.print, color: AppColors.primary, size: 24.r),
            SizedBox(width: 8.w),
            Text("Printing ID Card", style: AppTextStyles.titleMedium),
          ],
        ),
        content: Text(
          "Connecting to printer...\nPrinting ID Card for $name (UHID: $uhid).",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _simulateDownload(String name, String uhid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09121F)
            : Colors.white,
        title: Row(
          children: [
            Icon(Icons.download, color: AppColors.primary, size: 24.r),
            SizedBox(width: 8.w),
            Text("Downloading ID Card", style: AppTextStyles.titleMedium),
          ],
        ),
        content: Text(
          "Generating PDF...\nID Card for $name (UHID: $uhid) downloaded successfully to your Downloads directory.",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white70
                      : AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: valueFontWeight ?? FontWeight.w500,
                color: valueColor ?? (AppColors.textPrimary(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr =
        widget.record['recorded_at'] ?? widget.record['created_at'] ?? '';
    String formattedDate = 'N/A';
    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr);
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 950;

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Registration Details"),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _patientDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userMap = snapshot.data;
          final String notes = widget.record['prescription_notes'] ?? '';

          final uhid =
              userMap?['patient_id'] ??
              RegExp(r'UHID:\s*([^\s.]+)').firstMatch(notes)?.group(1) ??
              widget.record['invoice_number']?.replaceAll('REG-', 'CCH25-') ??
              'CCH25-9999999';

          final patientName =
              userMap?['name'] ?? widget.record['patient_name'] ?? 'N/A';
          final firstName =
              userMap?['first_name'] ??
              (patientName.split(' ').isNotEmpty
                  ? patientName.split(' ').first
                  : 'N/A');
          final lastName =
              userMap?['last_name'] ??
              (patientName.split(' ').length > 1
                  ? patientName.split(' ').last
                  : '');
          final phone = userMap?['phone_number'] ?? 'N/A';
          final dob = userMap?['date_of_birth'] ?? 'N/A';
          final sex = userMap?['gender'] ?? 'Male';
          final bloodGroup = userMap?['blood_group'] ?? 'O+';
          final address =
              userMap?['address'] ??
              RegExp(r'Address:\s*([^\n]+)').firstMatch(notes)?.group(1) ??
              'N/A';
          final photoPath = userMap?['profile_image'] ?? '';

          // Emergency Contact
          Map<String, dynamic> emergencyMap = {};
          try {
            if (userMap?['emergency_contact'] != null) {
              emergencyMap = jsonDecode(userMap?['emergency_contact']);
            }
          } catch (_) {}
          final emergencyName =
              emergencyMap['name'] ??
              RegExp(
                r'Emergency Contact:\s*([^(]+)',
              ).firstMatch(notes)?.group(1)?.trim() ??
              'N/A';
          final emergencyRelationship =
              emergencyMap['relationship'] ??
              RegExp(
                r'Emergency Contact:[^(]+\(([^)]+)\)',
              ).firstMatch(notes)?.group(1) ??
              'N/A';
          final emergencyPhone =
              emergencyMap['phone'] ??
              RegExp(
                r'Emergency Contact:[^-]+-\s*([^\s.]+)',
              ).firstMatch(notes)?.group(1) ??
              'N/A';

          // Metadata / Lifestyle / Insurance
          Map<String, dynamic> meta = userMap?['metadata'] ?? {};
          final genderIdentity = meta['gender_identity'] ?? 'Cisgender Male';
          final place =
              meta['place'] ??
              RegExp(r'Place:\s*([^\n]+)').firstMatch(notes)?.group(1) ??
              'Local Area';
          final wardNum = meta['ward_num'] ?? 'N/A';
          final insuranceProvider =
              userMap?['insurance_provider'] ??
              RegExp(
                r'Insurance:\s*([^(]+)',
              ).firstMatch(notes)?.group(1)?.trim() ??
              'None';
          final insurancePolicyId =
              userMap?['insurance_number'] ??
              RegExp(
                r'Insurance:[^(]+\(ID:\s*([^)]+)\)',
              ).firstMatch(notes)?.group(1) ??
              'N/A';
          final insuranceValidTill = meta['insurance_valid_till'] ?? 'N/A';

          final smoking =
              meta['smoking'] ??
              RegExp(r'Smoking\s*\(([^)]+)\)').firstMatch(notes)?.group(1) ??
              'No';
          final alcohol =
              meta['alcohol'] ??
              RegExp(r'Alcohol\s*\(([^)]+)\)').firstMatch(notes)?.group(1) ??
              'No';
          final dietType =
              meta['diet_type'] ??
              RegExp(r'Diet\s*\(([^)]+)\)').firstMatch(notes)?.group(1) ??
              'Veg';
          final exercise =
              meta['exercise'] ??
              RegExp(r'Exercise\s*\(([^)]+)\)').firstMatch(notes)?.group(1) ??
              'None';
          final allergies =
              meta['allergies'] ??
              RegExp(r'Allergies:\s*([^\s.]+)').firstMatch(notes)?.group(1) ??
              'None';
          final otherDetails = meta['other_details'] ?? 'None';

          // Visual Cards list
          final detailCards = [
            _buildDetailCard(
              title: "Personal Information",
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.primary,
              isDark: isDark,
              children: [
                _buildInfoRow(
                  "UHID",
                  uhid,
                  isDark,
                  valueColor: AppColors.primary,
                  valueFontWeight: FontWeight.bold,
                ),
                _buildInfoRow("First Name", firstName, isDark),
                _buildInfoRow("Last Name", lastName, isDark),
                _buildInfoRow("Email", userMap?['email'] ?? 'N/A', isDark),
                _buildInfoRow("Phone", phone, isDark),
                _buildInfoRow("DOB", dob, isDark),
                _buildInfoRow("Sex", sex, isDark),
                _buildInfoRow("Gender Identity", genderIdentity, isDark),
                _buildInfoRow("Blood Group", bloodGroup, isDark),
              ],
            ),
            SizedBox(height: 16.h),
            _buildDetailCard(
              title: "Address Information",
              icon: Icons.home_work_outlined,
              iconColor: Colors.blue,
              isDark: isDark,
              children: [
                _buildInfoRow("Place / Area", place, isDark),
                _buildInfoRow("Ward Number", wardNum, isDark),
                _buildInfoRow(
                  "Pincode",
                  address.contains('-')
                      ? address.split('-').last.trim()
                      : 'N/A',
                  isDark,
                ),
                _buildInfoRow("Full Address", address, isDark),
              ],
            ),
            SizedBox(height: 16.h),
            _buildDetailCard(
              title: "Insurance Details",
              icon: Icons.admin_panel_settings_outlined,
              iconColor: Colors.purple,
              isDark: isDark,
              children: [
                _buildInfoRow("Insurance Provider", insuranceProvider, isDark),
                _buildInfoRow("Policy Number / ID", insurancePolicyId, isDark),
                _buildInfoRow("Valid Till", insuranceValidTill, isDark),
              ],
            ),
            SizedBox(height: 16.h),
            _buildDetailCard(
              title: "Lifestyle Details",
              icon: Icons.health_and_safety_outlined,
              iconColor: Colors.teal,
              isDark: isDark,
              children: [
                _buildInfoRow("Smoking", smoking, isDark),
                _buildInfoRow("Alcohol", alcohol, isDark),
                _buildInfoRow("Diet Type", dietType, isDark),
                _buildInfoRow("Exercise", exercise, isDark),
                _buildInfoRow("Allergies", allergies, isDark),
                _buildInfoRow("Other Details", otherDetails, isDark),
              ],
            ),
            SizedBox(height: 16.h),
            _buildDetailCard(
              title: "Emergency Contact",
              icon: Icons.contact_phone_outlined,
              iconColor: Colors.red,
              isDark: isDark,
              children: [
                _buildInfoRow("Contact Name", emergencyName, isDark),
                _buildInfoRow("Relationship", emergencyRelationship, isDark),
                _buildInfoRow("Phone Number", emergencyPhone, isDark),
              ],
            ),
          ];

          // Hero status header
          Widget buildHeroHeader() {
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [const Color(0xFFF1F5F9), Colors.white],
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey[200]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.assignment_ind_outlined,
                      color: AppColors.primary,
                      size: 32.r,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Registered: $formattedDate",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: _paymentStatus == 'Paid'
                          ? AppColors.success.withValues(alpha: 0.15)
                          : Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: _paymentStatus == 'Paid'
                            ? AppColors.success
                            : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _paymentStatus == 'Paid' ? "PAID" : "PENDING FEE",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _paymentStatus == 'Paid'
                            ? AppColors.success
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Interactive action cards (Payment details or ID Card options)
          Widget buildActionSection() {
            if (_paymentStatus == 'Pending') {
              return Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Registration Fee Details",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Fee Amount", style: AppTextStyles.bodyMedium),
                        Text(
                          "₹200.00",
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Select Payment Mode",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Cash'),
                            selected: _payMethod == 'Cash',
                            onSelected: (val) {
                              if (val) setState(() => _payMethod = 'Cash');
                            },
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('UPI / QR'),
                            selected: _payMethod == 'Online',
                            onSelected: (val) {
                              if (val) setState(() => _payMethod = 'Online');
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_payMethod == 'Online') ...[
                      SizedBox(height: 20.h),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.qr_code_scanner,
                            size: 140.r,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Center(
                        child: Text(
                          "Scan QR Code with any UPI App to Pay",
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isPaying
                            ? null
                            : () async {
                                setState(() => _isPaying = true);
                                await _confirmRegistrationPayment(
                                  widget.record,
                                  _payMethod,
                                );
                                setState(() {
                                  _isPaying = false;
                                  _paymentStatus = 'Paid';
                                });

                                if (context.mounted) {
                                  context.read<EmrdBloc>().add(LoadEmrdStats());
                                  _showPaymentSuccessDialog(
                                    context,
                                    patientName,
                                    uhid,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: _isPaying
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Confirm Payment",
                                style: AppTextStyles.buttonMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient ID Card Preview",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    IdCardPreview(
                      firstName: firstName,
                      lastName: lastName,
                      dob: dob,
                      sex: sex,
                      bloodGroup: bloodGroup,
                      phone: phone,
                      uhid: uhid,
                      photoPath: photoPath,
                      address: address,
                      emergencyName: emergencyName,
                      emergencyRelationship: emergencyRelationship,
                      emergencyPhone: emergencyPhone,
                      selectedTab: _idCardTab,
                      onTabChanged: (tab) => setState(() => _idCardTab = tab),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _simulatePrint(patientName, uhid),
                            icon: const Icon(
                              Icons.print,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              "Print Card",
                              style: TextStyle(color: AppColors.primary),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _simulateDownload(patientName, uhid),
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Download Card",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeroHeader(),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: Column(children: detailCards)),
                      SizedBox(width: 24.w),
                      Expanded(flex: 4, child: buildActionSection()),
                    ],
                  )
                else ...[
                  buildActionSection(),
                  SizedBox(height: 20.h),
                  ...detailCards,
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
