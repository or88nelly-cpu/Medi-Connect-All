import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';

class SpecialityFormDialog extends StatefulWidget {
  final SpecialityEntity? existingSpeciality;

  const SpecialityFormDialog({super.key, this.existingSpeciality});

  static void show(BuildContext context, {SpecialityEntity? existingSpeciality}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<SpecialityBloc>(),
        child: SpecialityFormDialog(existingSpeciality: existingSpeciality),
      ),
    );
  }

  @override
  State<SpecialityFormDialog> createState() => _SpecialityFormDialogState();
}

class _SpecialityFormDialogState extends State<SpecialityFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _feeCtrl;
  late TextEditingController _durationCtrl;
  String _selectedIcon = 'cardiology';
  bool _isSurgical = false;
  bool _isActive = true;

  final List<String> _iconOptions = [
    'cardiology',
    'neurology',
    'pediatrics',
    'orthopedics',
    'dermatology',
    'surgery',
    'general'
  ];

  @override
  void initState() {
    super.initState();
    final spec = widget.existingSpeciality;
    _nameCtrl = TextEditingController(text: spec?.name ?? '');
    _codeCtrl = TextEditingController(text: spec?.specialityCode ?? '');
    _descCtrl = TextEditingController(text: spec?.description ?? '');
    _feeCtrl = TextEditingController(
        text: spec?.defaultConsultationFee != null
            ? spec!.defaultConsultationFee!.toStringAsFixed(2)
            : '0.00');
    _durationCtrl = TextEditingController(
        text: spec?.consultationDuration != null
            ? spec!.consultationDuration.toString()
            : '15');
    _selectedIcon = spec?.icon ?? 'cardiology';
    _isSurgical = spec?.isSurgical ?? false;
    _isActive = spec?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    _feeCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return AlertDialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        widget.existingSpeciality == null ? "Add Speciality" : "Edit Speciality",
        style: AppTextStyles.titleLarge.copyWith(color: textColor, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 320.w,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: "Speciality Name *"),
                  validator: (val) => val == null || val.isEmpty ? "Name is required" : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _codeCtrl,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: "Speciality Code *"),
                  validator: (val) => val == null || val.isEmpty ? "Code is required" : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 2,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  value: _selectedIcon,
                  dropdownColor: cardBg,
                  style: TextStyle(color: textColor),
                  decoration: const InputDecoration(labelText: "Icon Category"),
                  items: _iconOptions.map((icon) {
                    return DropdownMenuItem(
                      value: icon,
                      child: Text(icon.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedIcon = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _feeCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: r"Consultation Fee ($)"),
                        validator: (val) => val == null || double.tryParse(val) == null
                            ? "Invalid fee"
                            : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextFormField(
                        controller: _durationCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: textColor),
                        decoration: const InputDecoration(labelText: "Duration (mins)"),
                        validator: (val) => val == null || int.tryParse(val) == null
                            ? "Invalid duration"
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SwitchListTile(
                  title: Text("Is Surgical", style: AppTextStyles.bodyMedium.copyWith(color: textColor)),
                  value: _isSurgical,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() {
                      _isSurgical = val;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text("Is Active", style: AppTextStyles.bodyMedium.copyWith(color: textColor)),
                  value: _isActive,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() {
                      _isActive = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: AppColors.textSecondary(context))),
        ),
        BlocConsumer<SpecialityBloc, SpecialityState>(
          listener: (context, state) {
            if (state is SpecialityActionSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return CommonButton(
              text: widget.existingSpeciality == null ? "Create" : "Save",
              isLoading: state is SpecialityLoading,
              width: 80.w,
              height: 36.h,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final entity = SpecialityEntity(
                    id: widget.existingSpeciality?.id ?? '',
                    specialityCode: _codeCtrl.text.trim(),
                    name: _nameCtrl.text.trim(),
                    description: _descCtrl.text.trim(),
                    icon: _selectedIcon,
                    consultationDuration: int.parse(_durationCtrl.text),
                    defaultConsultationFee: double.parse(_feeCtrl.text),
                    isSurgical: _isSurgical,
                    isActive: _isActive,
                  );

                  if (widget.existingSpeciality == null) {
                    context.read<SpecialityBloc>().add(CreateSpecialityEvent(entity));
                  } else {
                    context.read<SpecialityBloc>().add(UpdateSpecialityEvent(entity));
                  }
                }
              },
            );
          },
        ),
      ],
    );
  }
}
