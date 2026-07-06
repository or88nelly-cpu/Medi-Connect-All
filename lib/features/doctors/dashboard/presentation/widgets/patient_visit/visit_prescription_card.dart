import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';

class VisitPrescriptionCard extends StatefulWidget {
  final List<Map<String, dynamic>> medicines;
  final TextEditingController searchCtrl;
  final VoidCallback onAddMedicine;
  final ValueChanged<int> onRemoveMedicine;
  final String selectedType;
  final String selectedDosage;
  final String selectedFreq;
  final String selectedDuration;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onDosageChanged;
  final ValueChanged<String> onFreqChanged;
  final ValueChanged<String> onDurationChanged;
  final bool isEditable;

  const VisitPrescriptionCard({
    super.key,
    required this.medicines,
    required this.searchCtrl,
    required this.onAddMedicine,
    required this.onRemoveMedicine,
    required this.selectedType,
    required this.selectedDosage,
    required this.selectedFreq,
    required this.selectedDuration,
    required this.onTypeChanged,
    required this.onDosageChanged,
    required this.onFreqChanged,
    required this.onDurationChanged,
    this.isEditable = true,
  });

  @override
  State<VisitPrescriptionCard> createState() => _VisitPrescriptionCardState();
}

class _VisitPrescriptionCardState extends State<VisitPrescriptionCard> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey[600];
    final borderCol = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.receipt_long,
                color: const Color(0xFF3B82F6),
                size: 18.r,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Prescription',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (widget.isEditable) ...[
              IconButton(
                icon: Icon(
                  Icons.keyboard_alt_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.mic_none_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isEditable) ...[
                // Search autocomplete
                BlocBuilder<AdminPharmacyBloc, AdminPharmacyState>(
                  builder: (context, pharmacyState) {
                    List<String> suggestions = [];
                    if (pharmacyState is AdminPharmacyLoaded) {
                      suggestions = pharmacyState.items
                          .map((i) => i.name)
                          .toList();
                    }

                    return RawAutocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return suggestions.where((String option) {
                          return option.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          );
                        });
                      },
                      fieldViewBuilder:
                          (
                            context,
                            textController,
                            focusNode,
                            onFieldSubmitted,
                          ) {
                            textController.addListener(() {
                              widget.searchCtrl.text = textController.text;
                            });

                            return TextField(
                              controller: textController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                hintText:
                                    'Search medicine (e.g. Paracetamol...)',
                                hintStyle: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 12.sp,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 18.r,
                                  color: secondaryTextColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: borderCol),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              width: 300.w,
                              constraints: BoxConstraints(maxHeight: 200.h),
                              color: cardBg,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(
                                    index,
                                  );
                                  return ListTile(
                                    title: Text(
                                      option,
                                      style: TextStyle(
                                        color: primaryTextColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 12.h),

                // Dropdown selectors row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildDropDown(
                        label: 'Type',
                        value: widget.selectedType,
                        items: ['Tab.', 'Cap.', 'Syr.', 'Inj.', 'Oint.'],
                        onChanged: (v) => widget.onTypeChanged(v!),
                        isDark: isDark,
                        borderCol: borderCol,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: _buildDropDown(
                        label: 'Dosage',
                        value: widget.selectedDosage,
                        items: ['650 mg', '500 mg', '250 mg', '10 ml', '5 ml'],
                        onChanged: (v) => widget.onDosageChanged(v!),
                        isDark: isDark,
                        borderCol: borderCol,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: _buildDropDown(
                        label: 'Frequency',
                        value: widget.selectedFreq,
                        items: ['1-0-1', '1-0-0', '0-1-0', '1-1-1', '0-0-1'],
                        onChanged: (v) => widget.onFreqChanged(v!),
                        isDark: isDark,
                        borderCol: borderCol,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: _buildDropDown(
                        label: 'Duration',
                        value: widget.selectedDuration,
                        items: [
                          '5 Days',
                          '3 Days',
                          '7 Days',
                          '10 Days',
                          '30 Days',
                        ],
                        onChanged: (v) => widget.onDurationChanged(v!),
                        isDark: isDark,
                        borderCol: borderCol,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: widget.onAddMedicine,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Medicine'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // Prescribed Medicines list
              if (widget.medicines.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'No medications prescribed.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else ...[
                Text(
                  'Prescribed Medicines:',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.medicines.length,
                  itemBuilder: (context, index) {
                    final med = widget.medicines[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 10.w,
                      ),
                      margin: EdgeInsets.only(bottom: 6.h),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white10
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${med['type']} ${med['name']} — ${med['dosage']} | ${med['frequency']} | ${med['days']}',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (widget.isEditable)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                              onPressed: () => widget.onRemoveMedicine(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropDown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    required Color borderCol,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey[500],
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderCol),
            color: isDark ? Colors.white10 : Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textDarkNavy,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
