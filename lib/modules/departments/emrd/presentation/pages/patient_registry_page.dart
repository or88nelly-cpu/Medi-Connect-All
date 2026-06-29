import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_list_item_card.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/pages/patient_registration_record_detail_page.dart';

class PatientRegistryPage extends StatefulWidget {
  const PatientRegistryPage({super.key});

  @override
  State<PatientRegistryPage> createState() => _PatientRegistryPageState();
}

class _PatientRegistryPageState extends State<PatientRegistryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Container();
  }
  
}
