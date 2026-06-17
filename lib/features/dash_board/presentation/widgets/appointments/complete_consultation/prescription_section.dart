import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/buttons/buttons.dart';
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'complete_consultation_cubit.dart';
import 'consultation_section_header.dart';

class PrescriptionSection extends StatelessWidget {
  final TextEditingController prescriptionNotesCtrl;

  const PrescriptionSection({super.key, required this.prescriptionNotesCtrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    // Retrieve pharmacy items for Autocomplete
    List<PharmacyItemEntity> pharmacyItems = [];
    final pharmacyState = context.watch<AdminPharmacyBloc>().state;
    if (pharmacyState is AdminPharmacyLoaded) {
      pharmacyItems = pharmacyState.items;
      cubit.setPharmacyItems(pharmacyItems);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConsultationSectionHeader(
          icon: Icons.description_outlined,
          title: 'A. Prescription',
          subtitle: 'Add medicines and notes',
          color: AppColors.primary,
        ),
        SizedBox(height: 12.h),

        // Table Header
        if (state.medicines.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Medicine Name',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Dosage (e.g. 1-0-1)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Duration (Days)',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ),
                SizedBox(width: 36.w), // Spacer for delete button
              ],
            ),
          ),

        // Medicine Rows
        ...List.generate(state.medicines.length, (i) {
          final row = state.medicines[i];
          final nameCtrl = row['name'] as TextEditingController;
          final dosageCtrl = row['dosage'] as TextEditingController;
          final freqCtrl = row['frequency'] as TextEditingController;
          final daysCtrl = row['days'] as TextEditingController;
          final focusNode = row['focusNode'] as FocusNode;

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medicine Name Autocomplete
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RawAutocomplete<PharmacyItemEntity>(
                        textEditingController: nameCtrl,
                        focusNode: focusNode,
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<PharmacyItemEntity>.empty();
                          }
                          return pharmacyItems.where((
                            PharmacyItemEntity option,
                          ) {
                            return option.name.toLowerCase().contains(
                              textEditingValue.text.toLowerCase(),
                            );
                          });
                        },
                        displayStringForOption: (PharmacyItemEntity option) =>
                            option.name,
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return TextField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search medicine...',
                                  hintStyle: AppTextStyles.bodySmall.copyWith(
                                    color: isDark
                                        ? Colors.white38
                                        : AppColors.textSecondary(context),
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? AppColors.terminalDarkBg
                                      : Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 10.h,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: AppColors.border(context),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                        optionsViewBuilder:
                            (
                              BuildContext context,
                              AutocompleteOnSelected<PharmacyItemEntity>
                              onSelected,
                              Iterable<PharmacyItemEntity> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: isDark
                                      ? AppColors.terminalDarkCard
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Container(
                                    width: 250.w,
                                    constraints: BoxConstraints(
                                      maxHeight: 200.h,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.border(context),
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final PharmacyItemEntity option =
                                            options.elementAt(index);
                                        return InkWell(
                                          onTap: () => onSelected(option),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 10.h,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: isDark
                                                      ? AppColors
                                                            .terminalDarkBorder
                                                            .withValues(
                                                              alpha: 0.5,
                                                            )
                                                      : AppColors.border(
                                                          context,
                                                        ).withValues(
                                                          alpha: 0.5,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        option.name,
                                                        style: AppTextStyles
                                                            .bodyMedium
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  AppColors.textPrimary(
                                                                    context,
                                                                  ),
                                                            ),
                                                      ),
                                                      if (option
                                                          .dosage
                                                          .isNotEmpty) ...[
                                                        SizedBox(height: 2.h),
                                                        Text(
                                                          'Dosage: ${option.dosage}',
                                                          style: AppTextStyles
                                                              .bodySmall
                                                              .copyWith(
                                                                color:
                                                                    AppColors.textSecondary(
                                                                      context,
                                                                    ),
                                                              ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '₹${option.sellPrice}',
                                                  style: AppTextStyles.bodySmall
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                        onSelected: (PharmacyItemEntity selection) {
                          cubit.selectMedicine(i, selection);
                        },
                      ),
                      if (dosageCtrl.text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h, left: 4.w),
                          child: Text(
                            'Strength: ${dosageCtrl.text}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? Colors.white38
                                  : AppColors.textSecondary(context),
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Dosage / Frequency TextField
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: freqCtrl,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 1-0-1',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white38
                            : AppColors.textSecondary(context),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.terminalDarkBg
                          : Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.border(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Duration (Days) TextField
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: daysCtrl,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Days',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white38
                            : AppColors.textSecondary(context),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.terminalDarkBg
                          : Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.border(context),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Delete Button
                SizedBox(
                  width: 36.w,
                  child: Center(
                    child: AppIconButton(
                      icon: Icons.delete_outline,
                      color: state.medicines.length > 1
                          ? AppColors.error
                          : Colors.grey,
                      onPressed: () {
                        if (state.medicines.length > 1) {
                          cubit.removeMedicineRow(i);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        SizedBox(height: 4.h),
        OutlinedButton.icon(
          onPressed: () => cubit.addMedicineRow(),
          icon: Icon(Icons.add, size: 16.r, color: AppColors.primary),
          label: Text(
            'Add Medicine',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          ),
        ),
        SizedBox(height: 12.h),

        // Prescription notes / remarks
        TextField(
          controller: prescriptionNotesCtrl,
          maxLines: 3,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary(context),
          ),
          decoration: InputDecoration(
            hintText: 'Prescription notes / doctor remarks...',
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
            filled: true,
            fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
