import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';

/// Modal bottom-sheet form for creating or editing a department.
/// Uses ValueNotifier for local UI state — no setState.
class DepartmentFormDialog extends StatelessWidget {
  final DepartmentEntity? existingDepartment;

  const DepartmentFormDialog({super.key, this.existingDepartment});

  static Future<void> show(
    BuildContext context, {
    DepartmentEntity? existingDepartment,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<DepartmentBloc>(),
        child: DepartmentFormDialog(existingDepartment: existingDepartment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _DepartmentFormContent(existingDepartment: existingDepartment);
  }
}

class _DepartmentFormContent extends StatefulWidget {
  final DepartmentEntity? existingDepartment;

  const _DepartmentFormContent({this.existingDepartment});

  @override
  State<_DepartmentFormContent> createState() => _DepartmentFormContentState();
}

class _DepartmentFormContentState extends State<_DepartmentFormContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _imageController;

  // ValueNotifier for preview image URL — no setState on the page.
  late final ValueNotifier<String> _imagePreviewNotifier;

  bool get _isEditing => widget.existingDepartment != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingDepartment?.name ?? '',
    );
    _descController = TextEditingController(
      text: widget.existingDepartment?.description ?? '',
    );
    _imageController = TextEditingController(
      text: widget.existingDepartment?.imageUrl ?? '',
    );
    _imagePreviewNotifier = ValueNotifier(
      widget.existingDepartment?.imageUrl ?? '',
    );

    _imageController.addListener(
      () => _imagePreviewNotifier.value = _imageController.text.trim(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _imageController.dispose();
    _imagePreviewNotifier.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    final imageUrl = _imageController.text.trim();

    if (_isEditing) {
      context.read<DepartmentBloc>().add(
        UpdateDepartmentEvent(
          id: widget.existingDepartment!.id,
          name: name,
          description: desc.isEmpty ? null : desc,
          imageUrl: imageUrl.isEmpty ? null : imageUrl,
        ),
      );
    } else {
      context.read<DepartmentBloc>().add(
        AddDepartmentEvent(
          name: name,
          description: desc.isEmpty ? null : desc,
          imageUrl: imageUrl.isEmpty ? null : imageUrl,
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + bottomPad),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle bar ────────────────────────────────
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ── Title ─────────────────────────────────────
              Text(
                _isEditing
                    ? AppStrings.editDepartment
                    : AppStrings.addDepartment,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 20.h),

              // ── Name (required) ───────────────────────────
              AppTextField(
                controller: _nameController,
                labelText: AppStrings.departmentNameLabel,
                hintText: AppStrings.departmentNameHint,
                prefixIcon: Icon(
                  Icons.local_hospital_outlined,
                  color: labelColor,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return AppStrings.requiredField;
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              // ── Description (optional) ────────────────────
              AppTextField(
                controller: _descController,
                labelText: AppStrings.departmentDescLabel,
                hintText: AppStrings.departmentDescHint,
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: labelColor,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Image URL (optional) ──────────────────────
              AppTextField(
                controller: _imageController,
                labelText: AppStrings.departmentImageLabel,
                hintText: AppStrings.departmentImageHint,
                prefixIcon: Icon(
                  Icons.image_outlined,
                  color: labelColor,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Image Preview ─────────────────────────────
              ValueListenableBuilder<String>(
                valueListenable: _imagePreviewNotifier,
                builder: (context, url, _) {
                  if (url.isEmpty) return const SizedBox.shrink();
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CustomImageView(
                      imagePath: url,
                      width: double.infinity,
                      height: 120.h,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        height: 120.h,
                        alignment: Alignment.center,
                        color: isDark ? AppColors.terminalDarkBg : AppColors.terminalLightBg,
                        child: Text(
                          'Invalid image URL',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: labelColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),

              // ── Submit ────────────────────────────────────
              BlocBuilder<DepartmentBloc, DepartmentState>(
                builder: (context, state) {
                  return GradientButton(
                    isLoading: state is DepartmentLoading,
                    text: _isEditing
                        ? AppStrings.editDepartment
                        : AppStrings.addDepartment,
                    onPressed: () => _submit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
