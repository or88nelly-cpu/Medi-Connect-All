import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_action_card.dart';

class PatientActionBanners extends StatelessWidget {
  const PatientActionBanners({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215.h,
      child: Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: -40, end: 0),
              builder: (_, value, child) {
                return Transform.translate(
                  offset: Offset(value, 0),
                  child: Opacity(
                    opacity: (40 - value.abs()) / 40,
                    child: child,
                  ),
                );
              },
              child: PatientActionCard(
                title: "Complete\nRegistration",
                description:
                    "Complete your profile to unlock appointments and all healthcare services.",
                buttonText: "Complete Now",
                status: "Pending",
                icon: Icons.assignment_rounded,
                primaryColor: const Color(0xffFF2D7A),
                secondaryColor: const Color(0xffFFD8E7),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Registration coming soon")),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 40, end: 0),
              builder: (_, value, child) {
                return Transform.translate(
                  offset: Offset(value, 0),
                  child: Opacity(
                    opacity: (40 - value.abs()) / 40,
                    child: child,
                  ),
                );
              },
              child: PatientActionCard(
                title: "Payment Due",
                description: "You have an outstanding balance to clear.",
                amount: "₹500",
                buttonText: "Pay Now",
                status: "Due",
                icon: Icons.account_balance_wallet_rounded,
                primaryColor: const Color(0xffFF8A00),
                secondaryColor: const Color(0xffFFE8B8),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Payment gateway coming soon"),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
