import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/utils/department_utils.dart';
import 'package:medi_connect/modules/staff/department/widgets/common_card.dart';

class CustomerCare extends StatelessWidget {
  const CustomerCare({super.key});

  @override
  Widget build(BuildContext context) {
    final (padding, count) = getGridInfo(width: 165.w);
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            spacing: padding,
            runSpacing: padding,
            children: [
              CommonCard(
                title: "Registration",
                subTitle: "Register new patient manually",
                icon: Icons.person_add_alt_1,
                color: const Color(0xff2D7FFF),
              ),
              CommonCard(
                title: "QR Reg",
                subTitle: "Scan QR code to register patient",
                icon: Icons.qr_code_2,
                color: const Color(0xff00D5C7),
              ),
              CommonCard(
                title: "Appointment",
                subTitle: "Manage appointments",
                icon: Icons.calendar_month,
                color: const Color(0xff8A4DFF),
              ),
              CommonCard(
                title: "Patient",
                subTitle: "Search by UHID or mobile",
                icon: Icons.person_search,
                color: const Color(0xff3366FF),
              ),
              CommonCard(
                title: "Admission",
                subTitle: "New admissions & stays",
                icon: Icons.bed,
                color: const Color(0xffFF981F),
              ),

              CommonCard(
                title: "Feedback",
                subTitle: "Patient ratings & reviews",
                icon: Icons.star_outline,
                color: const Color(0xffFF4D8D),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
