import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/common_widgets/calender_painter.dart';

class DynamicCalendar3D extends StatelessWidget {
  final DateTime date;
  final double size;

  const DynamicCalendar3D({super.key, required this.date, this.size = 120});

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('MMM').format(date).toUpperCase();
    final day = date.day.toString();

    return SizedBox(
      width: size,
      height: size * 1.15,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFA855F7).withValues(alpha: .25),
            ),
          ),

          Transform.rotate(
            angle: -0.15,
            child: CustomPaint(
              size: Size(size, size * 1.15),
              painter: CalendarPainter(),
              child: SizedBox(
                width: size,
                height: size * 1.15,
                child: Column(
                  children: [
                    SizedBox(height: size * .08),

                    Text(
                      month,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: size * .12,
                      ),
                    ),

                    Text(
                      day,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: size * .28,
                        height: .9,
                      ),
                    ),

                    SizedBox(height: size * .12),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: size * .12),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 25,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                              ),
                          itemBuilder: (_, _) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.white.withValues(alpha: .12),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
