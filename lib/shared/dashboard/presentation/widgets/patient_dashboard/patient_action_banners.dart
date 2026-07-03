import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_action_card.dart';

class PatientActionBanners extends StatelessWidget {
  const PatientActionBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.h,
      child: Row(
        children: [
          Expanded(
            child: PatientActionCard(
              title: "Complete\nRegistration",
              description:
                  "Complete your profile to unlock appointments and hospital services.",
              status: "Pending",
              buttonText: "Complete Now",
              startColor: const Color(0xffFF3E7F),
              endColor: const Color(0xffFF7EA8),
              icon: Icons.assignment_rounded,

              onPressed: () {},
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: PatientActionCard(
              title: "Payment\nDue",
              description: "Outstanding balance for your recent consultation.",
              amount: "₹500",
              status: "Due",
              buttonText: "Pay Now",
              startColor: const Color(0xffFF9800),
              endColor: const Color(0xffFFC107),
              icon: Icons.account_balance_wallet_rounded,

              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
