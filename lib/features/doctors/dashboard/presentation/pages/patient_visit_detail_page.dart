import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/boot_strap/services/secure_storage_service.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';

// Extracted Sub-widgets
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_patient_header.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_date_picker_row.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_vitals_grid.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_list_section.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_prescription_card.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/patient_visit/visit_fast_action_grid.dart';

class PatientVisitDetailPage extends StatefulWidget {
  final AppointmentEntity appointment;
  final UserEntity patient;

  const PatientVisitDetailPage({
    super.key,
    required this.appointment,
    required this.patient,
  });

  @override
  State<PatientVisitDetailPage> createState() => _PatientVisitDetailPageState();
}

class _PatientVisitDetailPageState extends State<PatientVisitDetailPage> {
  // Navigation active date
  late DateTime _activeVisitDate;

  // List of all appointment dates for the patient
  List<DateTime> _appointmentDates = [];

  // Vitals Controllers
  late TextEditingController _bpCtrl;
  late TextEditingController _pulseCtrl;
  late TextEditingController _tempCtrl;
  late TextEditingController _spo2Ctrl;
  late TextEditingController _respRateCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _weightCtrl;
  late TextEditingController _bloodSugarCtrl;
  late TextEditingController _vitalsNotesCtrl;

  // Autocomplete controller for Medicine search
  final TextEditingController _medicineSearchCtrl = TextEditingController();

  // List of dynamic points
  final List<String> _historyPoints = [];
  final List<String> _doctorsNotes = [];
  final List<String> _chiefComplaints = [];

  // List of added medicines
  final List<Map<String, dynamic>> _medicines = [];

  // Prescription builder inputs
  String _selectedMedType = 'Tab.';
  String _selectedDosage = '650 mg';
  String _selectedFreq = '1-0-1';
  String _selectedDuration = '5 Days';

  bool _isSaving = false;
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _activeVisitDate = widget.appointment.appointmentDate;

    _bpCtrl = TextEditingController();
    _pulseCtrl = TextEditingController();
    _tempCtrl = TextEditingController();
    _spo2Ctrl = TextEditingController();
    _respRateCtrl = TextEditingController();
    _heightCtrl = TextEditingController();
    _weightCtrl = TextEditingController();
    _bloodSugarCtrl = TextEditingController();
    _vitalsNotesCtrl = TextEditingController();

    _loadDataForDate(_activeVisitDate);
    _loadAppointmentDates();
  }

  @override
  void dispose() {
    _bpCtrl.dispose();
    _pulseCtrl.dispose();
    _tempCtrl.dispose();
    _spo2Ctrl.dispose();
    _respRateCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _bloodSugarCtrl.dispose();
    _vitalsNotesCtrl.dispose();
    _medicineSearchCtrl.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  void _clearAllFields() {
    _bpCtrl.text = 'N/A';
    _pulseCtrl.text = 'N/A';
    _tempCtrl.text = 'N/A';
    _spo2Ctrl.text = 'N/A';
    _respRateCtrl.text = 'N/A';
    _heightCtrl.text = 'N/A';
    _weightCtrl.text = 'N/A';
    _bloodSugarCtrl.text = 'N/A';
    _vitalsNotesCtrl.clear();

    _chiefComplaints.clear();
    _historyPoints.clear();
    _doctorsNotes.clear();
    _medicines.clear();
  }

  void _populateTodayDefaults() {
    _bpCtrl.text = widget.appointment.bp ?? '120/80';
    _pulseCtrl.text = '78';
    _tempCtrl.text = widget.appointment.fever ?? '98.4';
    _spo2Ctrl.text = '98';
    _respRateCtrl.text = '18';
    _heightCtrl.text = widget.appointment.height ?? '175';
    _weightCtrl.text = widget.appointment.weight ?? '72';
    _bloodSugarCtrl.text = '108';
    _vitalsNotesCtrl.clear();

    _historyPoints.addAll([
      'No h/o major illness in the past',
      'No previous surgeries',
      'No known drug allergies except Penicillin',
      'Not on any regular medications',
      'Family history of Diabetes (Father)',
    ]);

    _doctorsNotes.addAll([
      'Patient is conscious, oriented',
      'No pallor, icterus, cyanosis',
      'CVS: S1 S2 normal, no murmurs',
      'RS: Bilateral air entry equal, no added sounds',
      'P/A: Soft, non tender',
    ]);

    _chiefComplaints.addAll([
      'Fever since 2 days',
      'Headache and body ache',
      'Cough with mild throat irritation',
    ]);

    _medicines.clear();
    _medicines.add({
      'type': 'Tab.',
      'name': 'Paracetamol',
      'dosage': '650 mg',
      'frequency': '1-0-1',
      'days': '5 Days',
    });
  }

  void _parseEMRNotes(String notes) {
    _chiefComplaints.clear();
    _historyPoints.clear();
    _doctorsNotes.clear();

    final lines = notes.split('\n');
    String section = '';

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('CHIEF COMPLAINTS:')) {
        section = 'complaints';
        continue;
      } else if (line.startsWith('HISTORY:')) {
        section = 'history';
        continue;
      } else if (line.startsWith('DOCTOR\'S CLINICAL NOTES:')) {
        section = 'notes';
        continue;
      }

      if (line.startsWith('- ')) {
        final content = line.substring(2);
        if (section == 'complaints') {
          _chiefComplaints.add(content);
        } else if (section == 'history') {
          _historyPoints.add(content);
        } else if (section == 'notes') {
          _doctorsNotes.add(content);
        }
      }
    }
  }

  void _parseEMRMedicines(String medicinesStr) {
    _medicines.clear();
    final lines = medicinesStr.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      try {
        final typeIndex = line.indexOf(' ');
        if (typeIndex == -1) continue;
        final type = line.substring(0, typeIndex);

        final parenIndex = line.indexOf('(');
        if (parenIndex == -1) continue;
        final name = line.substring(typeIndex + 1, parenIndex).trim();

        final details = line.substring(parenIndex + 1, line.length - 1);
        final parts = details.split(',');
        if (parts.length == 3) {
          _medicines.add({
            'type': type,
            'name': name,
            'dosage': parts[0].trim(),
            'frequency': parts[1].trim(),
            'days': parts[2].trim(),
          });
        }
      } catch (_) {}
    }
  }

  Future<void> _loadAppointmentDates() async {
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      final response = await supabase
          .from('appointments')
          .select('appointment_date')
          .eq('patient_id', widget.patient.id);

      if (response.isNotEmpty) {
        final List<DateTime> dates = [];
        for (final item in response) {
          if (item['appointment_date'] != null) {
            final date = DateTime.tryParse(item['appointment_date']);
            if (date != null) {
              dates.add(DateTime(date.year, date.month, date.day));
            }
          }
        }

        // Add today's date if not present
        final today = DateTime.now();
        final todayDateOnly = DateTime(today.year, today.month, today.day);
        if (!dates.any((d) => _isSameDay(d, todayDateOnly))) {
          dates.add(todayDateOnly);
        }

        // Sort dates chronologically
        dates.sort((a, b) => a.compareTo(b));

        setState(() {
          _appointmentDates = dates;
        });
      }
    } catch (e) {
      debugPrint("Error loading appointment dates: $e");
    }
  }

  Future<void> _loadDataForDate(DateTime date) async {
    final isToday = _isSameDay(date, DateTime.now());
    if (isToday) {
      setState(() {
        _clearAllFields();
        _populateTodayDefaults();
      });
      return;
    }

    setState(() {
      _isLoadingData = true;
      _clearAllFields();
    });

    final dateStr = date.toIso8601String().split('T').first;

    try {
      final supabase = GetIt.I<SupabaseService>().client;

      // Query appointments for patient on selected date
      final aptResponse = await supabase
          .from('appointments')
          .select()
          .eq('patient_id', widget.patient.id)
          .eq('appointment_date', dateStr)
          .maybeSingle();

      if (aptResponse != null) {
        setState(() {
          _bpCtrl.text = aptResponse['bp'] ?? 'N/A';
          _tempCtrl.text = aptResponse['fever'] ?? 'N/A';
          _heightCtrl.text = aptResponse['height'] ?? 'N/A';
          _weightCtrl.text = aptResponse['weight'] ?? 'N/A';
          _pulseCtrl.text = '78';
          _spo2Ctrl.text = '98';
          _respRateCtrl.text = '18';
          _bloodSugarCtrl.text = '108';
        });

        final isCompleted = aptResponse['status'] == 'Completed';
        if (isCompleted) {
          final emrResponse = await supabase
              .from('emr_records')
              .select()
              .eq('appointment_id', aptResponse['id'])
              .maybeSingle();

          if (emrResponse != null) {
            setState(() {
              final String meds = emrResponse['medicines'] ?? '';
              final String notes = emrResponse['prescription_notes'] ?? '';
              _parseEMRNotes(notes);
              _parseEMRMedicines(meds);
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading past consultation data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  void _navigateToPreviousAppointment() {
    final currentDateOnly = DateTime(
      _activeVisitDate.year,
      _activeVisitDate.month,
      _activeVisitDate.day,
    );

    DateTime? prevDate;
    for (final date in _appointmentDates.reversed) {
      if (date.isBefore(currentDateOnly)) {
        prevDate = date;
        break;
      }
    }

    if (prevDate != null) {
      setState(() {
        _activeVisitDate = prevDate!;
      });
      _loadDataForDate(prevDate);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No previous appointments found for this patient."),
        ),
      );
    }
  }

  void _navigateToNextAppointment() {
    final currentDateOnly = DateTime(
      _activeVisitDate.year,
      _activeVisitDate.month,
      _activeVisitDate.day,
    );

    DateTime? nextDate;
    for (final date in _appointmentDates) {
      if (date.isAfter(currentDateOnly)) {
        nextDate = date;
        break;
      }
    }

    if (nextDate != null) {
      setState(() {
        _activeVisitDate = nextDate!;
      });
      _loadDataForDate(nextDate);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No future appointments found for this patient."),
        ),
      );
    }
  }

  double _calculateBMI() {
    final h = double.tryParse(_heightCtrl.text);
    final w = double.tryParse(_weightCtrl.text);
    if (h != null && w != null && h > 0) {
      return w / ((h / 100) * (h / 100));
    }
    return 0.0;
  }

  void _addPointDialog(List<String> list, String title) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $title Point'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'Enter clinical point...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() {
                  list.add(ctrl.text.trim());
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addMedicine() {
    final medName = _medicineSearchCtrl.text.trim();
    if (medName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or search a medicine name')),
      );
      return;
    }

    setState(() {
      _medicines.add({
        'type': _selectedMedType,
        'name': medName,
        'dosage': _selectedDosage,
        'frequency': _selectedFreq,
        'days': _selectedDuration,
      });
      _medicineSearchCtrl.clear();
    });
  }

  Future<void> _saveDraft() async {
    setState(() => _isSaving = true);
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      await supabase.from('appointments').update({
        'bp': _bpCtrl.text,
        'weight': _weightCtrl.text,
        'height': _heightCtrl.text,
        'fever': _tempCtrl.text,
      }).eq('id', widget.appointment.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Draft saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save draft: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveAndClose() async {
    setState(() => _isSaving = true);
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      final apt = widget.appointment;

      // 1. Update appointment status and vitals
      await supabase.from('appointments').update({
        'status': 'Completed',
        'bp': _bpCtrl.text,
        'weight': _weightCtrl.text,
        'height': _heightCtrl.text,
        'fever': _tempCtrl.text,
      }).eq('id', apt.id);

      // 2. Build clinical notes summary for EMR
      final notesBuffer = StringBuffer();
      notesBuffer.writeln('CHIEF COMPLAINTS:');
      for (final p in _chiefComplaints) {
        notesBuffer.writeln('- $p');
      }
      notesBuffer.writeln('\nHISTORY:');
      for (final p in _historyPoints) {
        notesBuffer.writeln('- $p');
      }
      notesBuffer.writeln('\nDOCTOR\'S CLINICAL NOTES:');
      for (final p in _doctorsNotes) {
        notesBuffer.writeln('- $p');
      }
      if (_vitalsNotesCtrl.text.isNotEmpty) {
        notesBuffer.writeln('\nVITALS NOTES: ${_vitalsNotesCtrl.text}');
      }

      final medicinesStr = _medicines
          .map((m) => '${m['type']} ${m['name']} (${m['dosage']}, ${m['frequency']}, ${m['days']})')
          .join('\n');

      final recordedAtStr = DateTime.now().toIso8601String();
      final suffix = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
      final invoiceNum = 'INV-$suffix';

      final emrRecordData = {
        'patient_id': apt.patientId,
        'patient_name': apt.patientName,
        'doctor_id': apt.doctorId,
        'doctor_name': apt.doctorName,
        'specialty': apt.specialty,
        'appointment_id': apt.id,
        'medicines': medicinesStr,
        'lab_tests': '',
        'prescription_notes': notesBuffer.toString(),
        'invoice_number': invoiceNum,
        'amount': 500.0,
        'payment_method': 'Cash',
        'medicine_payment_status': 'Paid',
        'lab_payment_status': 'Paid',
        'medicine_amount': 0.0,
        'lab_amount': 0.0,
        'recorded_at': recordedAtStr,
      };

      // 3. Insert EMR record into DB
      await supabase.from('emr_records').insert(emrRecordData);

      // 4. Save EMR record to offline storage
      try {
        final storage = GetIt.I<SecureStorageService>();
        final localDataStr = await storage.read('emr_records');
        List<dynamic> list = [];
        if (localDataStr != null) {
          list = jsonDecode(localDataStr);
        }
        list.add(emrRecordData);
        await storage.write('emr_records', jsonEncode(list));
      } catch (_) {}

      // 5. Reload appointments list
      if (!mounted) return;
      context.read<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consultation completed and EMR record created!'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete consultation: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final pageBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderCol = AppColors.border(context);

    final calculatedBmi = _calculateBMI();
    final isToday = _isSameDay(_activeVisitDate, DateTime.now());

    return Stack(
      children: [
        Scaffold(
          backgroundColor: pageBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Patient List',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert, color: primaryTextColor),
                onPressed: () {},
              ),
            ],
          ),
          bottomNavigationBar: isToday
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border(
                      top: BorderSide(color: borderCol, width: 0.8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving ? null : _saveDraft,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text(
                            'Save Draft',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSaving ? null : _saveAndClose,
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text(
                            'Save & Close Visit',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F6FFF),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          body: _isLoadingData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Patient Profile Banner Card
                      VisitPatientHeader(
                        patient: widget.patient,
                        token: widget.appointment.token ?? 'DR001',
                      ),
                      SizedBox(height: 16.h),

                      // 2. Date Navigation Row
                      VisitDatePickerRow(
                        date: _activeVisitDate,
                        onPreviousPressed: _navigateToPreviousAppointment,
                        onNextPressed: _navigateToNextAppointment,
                      ),
                      SizedBox(height: 16.h),

                      // 3. Vitals Section
                      VisitVitalsGrid(
                        bpCtrl: _bpCtrl,
                        pulseCtrl: _pulseCtrl,
                        tempCtrl: _tempCtrl,
                        spo2Ctrl: _spo2Ctrl,
                        respRateCtrl: _respRateCtrl,
                        heightCtrl: _heightCtrl,
                        weightCtrl: _weightCtrl,
                        bloodSugarCtrl: _bloodSugarCtrl,
                        vitalsNotesCtrl: _vitalsNotesCtrl,
                        bmi: calculatedBmi,
                        onHeightOrWeightChanged: () => setState(() {}),
                        isEditable: isToday,
                      ),
                      SizedBox(height: 16.h),

                      // 4. History List Section
                      VisitListSection(
                        points: _historyPoints,
                        title: 'History',
                        description: 'Past illness, surgeries, medications, etc.',
                        icon: Icons.history,
                        iconColor: const Color(0xFF8B5CF6),
                        onAddPressed: () => _addPointDialog(_historyPoints, 'History'),
                        onRemovePressed: (idx) => setState(() => _historyPoints.removeAt(idx)),
                        isEditable: isToday,
                      ),
                      SizedBox(height: 16.h),

                      // 5. Doctor's Notes Section
                      VisitListSection(
                        points: _doctorsNotes,
                        title: "Doctor's Notes",
                        description: 'Clinical notes and examination findings',
                        icon: Icons.assignment_outlined,
                        iconColor: const Color(0xFF10B981),
                        onAddPressed: () => _addPointDialog(_doctorsNotes, "Doctor's Notes"),
                        onRemovePressed: (idx) => setState(() => _doctorsNotes.removeAt(idx)),
                        isEditable: isToday,
                      ),
                      SizedBox(height: 16.h),

                      // 6. Chief Complaints Section
                      VisitListSection(
                        points: _chiefComplaints,
                        title: 'Chief Complaints',
                        description: 'Patient reported symptoms and concerns',
                        icon: Icons.chat_bubble_outline,
                        iconColor: const Color(0xFFF59E0B),
                        onAddPressed: () => _addPointDialog(_chiefComplaints, 'Chief Complaints'),
                        onRemovePressed: (idx) => setState(() => _chiefComplaints.removeAt(idx)),
                        isEditable: isToday,
                      ),
                      SizedBox(height: 16.h),

                      // 7. Prescription Section
                      VisitPrescriptionCard(
                        medicines: _medicines,
                        searchCtrl: _medicineSearchCtrl,
                        selectedType: _selectedMedType,
                        selectedDosage: _selectedDosage,
                        selectedFreq: _selectedFreq,
                        selectedDuration: _selectedDuration,
                        onTypeChanged: (v) => setState(() => _selectedMedType = v),
                        onDosageChanged: (v) => setState(() => _selectedDosage = v),
                        onFreqChanged: (v) => setState(() => _selectedFreq = v),
                        onDurationChanged: (v) => setState(() => _selectedDuration = v),
                        onAddMedicine: _addMedicine,
                        onRemoveMedicine: (idx) => setState(() => _medicines.removeAt(idx)),
                        isEditable: isToday,
                      ),
                      SizedBox(height: 20.h),

                      // 8. Bottom Fast Action Grid
                      const VisitFastActionGrid(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
        if (_isSaving)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}
