import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/errors/custom_error_widget.dart';
import 'package:medi_connect/core/widgets/errors/empty_state_widget.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/features/management/consultation_management/presentation/widgets/emrd_list_item_card.dart';
import 'package:medi_connect/features/management/consultation_management/presentation/widgets/patient_registry_search_header.dart';
import 'package:medi_connect/features/management/patient_management/presentation/bloc/patient_bloc.dart';

class PatientRegistryPage extends StatefulWidget {
  const PatientRegistryPage({super.key});

  @override
  State<PatientRegistryPage> createState() => _PatientRegistryPageState();
}

class _PatientRegistryPageState extends State<PatientRegistryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _filterNotifier = ValueNotifier<String>('Name');

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    context.read<EmrdBloc>().add(LoadEmrdStats());
    _searchController.addListener(() {
      _queryNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    _filterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, patientState) {
        return BlocBuilder<EmrdBloc, EmrdState>(
          builder: (context, emrdState) {
            Widget bodyWidget;

            if (patientState is PatientLoading || emrdState is EmrdLoading) {
              bodyWidget = const Center(child: CircularProgressIndicator());
            } else if (patientState is PatientError) {
              bodyWidget = CustomErrorWidget(
                message: patientState.message,
                onRetry: () => context.read<PatientBloc>().add(LoadPatients()),
              );
            } else if (emrdState is EmrdError) {
              bodyWidget = CustomErrorWidget(
                message: emrdState.message,
                onRetry: () => context.read<EmrdBloc>().add(LoadEmrdStats()),
              );
            } else if (patientState is PatientLoaded &&
                emrdState is EmrdLoaded) {
              bodyWidget = _buildContent(
                patientState.patients,
                emrdState.emrRecords,
              );
            } else {
              bodyWidget = const SizedBox.shrink();
            }

            return CustomScaffold(
              customAppbar: const CommonAppBar(
                title: "Patient Registry & Identification",
              ),
              body: bodyWidget,
            );
          },
        );
      },
    );
  }

  Widget _buildContent(List<dynamic> patientsList, List<dynamic> emrRecords) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _queryNotifier,
            builder: (context, query, _) {
              return ValueListenableBuilder<String>(
                valueListenable: _filterNotifier,
                builder: (context, filter, _) {
                  final queryLower = query.toLowerCase().trim();
                  final filteredPatients = patientsList.where((p) {
                    if (queryLower.isEmpty) return true;
                    final name = (p.fullName).toLowerCase();
                    final uhid = (p.id).toLowerCase();
                    final phone = (p.phone ?? '').toLowerCase();

                    if (filter == 'UHID') {
                      return uhid.contains(queryLower);
                    } else if (filter == 'Phone') {
                      return phone.contains(queryLower);
                    } else {
                      return name.contains(queryLower);
                    }
                  }).toList();

                  return Column(
                    children: [
                      PatientRegistrySearchHeader(
                        searchController: _searchController,
                        filterNotifier: _filterNotifier,
                        queryNotifier: _queryNotifier,
                        recordCount: filteredPatients.length,
                      ),
                      SizedBox(height: 16.h),
                      if (filteredPatients.isEmpty)
                        const EmptyStateWidget(
                          title: "No Patients Found",
                          subtitle:
                              "Registered patients will be recorded and listed here.",
                          icon: Icons.badge_outlined,
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = filteredPatients[index];

                            final patientRecord = emrRecords.firstWhere(
                              (r) =>
                                  r['patient_id'] == patient.id &&
                                  r['specialty'] == 'Customer Care',
                              orElse: () => {
                                'patient_id': patient.id,
                                'patient_name':
                                    patient.fullName ?? 'Unnamed Patient',
                                'specialty': 'Customer Care',
                                'doctor_name': 'Customer Care Department',
                                'invoice_number':
                                    'REG-${patient.id.split('-').last ?? ""}',
                                'registration_fee': 200,
                                'registration_payment_status':
                                    patient.status == 'Active'
                                    ? 'Paid'
                                    : 'Pending',
                                'prescription_notes':
                                    'Initial patient registration from Customer Care. UHID: ${patient.id ?? ""}.',
                                'recorded_at': DateTime.now().toIso8601String(),
                              },
                            );

                            return EmrdListItemCard(
                              record: patientRecord,
                              onTap: () {
                                context.push(
                                  RouteNames.patientRegistrationRecordDetail,
                                  extra: patientRecord,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
