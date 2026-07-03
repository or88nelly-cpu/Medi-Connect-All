import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientActionCard extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final String? amount;
  final String status;

  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onPressed;

  const PatientActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.status,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onPressed,
    this.amount,
  });

  @override
  State<PatientActionCard> createState() => _PatientActionCardState();
}

class _PatientActionCardState extends State<PatientActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * -4),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: _pressed ? .97 : 1,
          child: Container(
            height: 205.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.primaryColor.withAlpha(20),
                  widget.secondaryColor.withAlpha(5),
                ],
              ),
              border: Border.all(color: widget.primaryColor.withAlpha(45)),
              boxShadow: [
                BoxShadow(
                  color: widget.primaryColor.withAlpha(25),
                  blurRadius: 30,
                  spreadRadius: 1,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30.w,
                  top: 60.h,
                  child: Container(
                    width: 120.r,
                    height: 120.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor.withAlpha(10),
                    ),
                  ),
                ),

                Positioned(
                  left: -20.w,
                  bottom: -25.h,
                  child: Container(
                    width: 90.r,
                    height: 90.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor.withAlpha(7),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 48.r,
                          width: 48.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(215),
                            boxShadow: [
                              BoxShadow(
                                color: widget.primaryColor.withAlpha(45),
                                blurRadius: 14.r,
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.primaryColor,
                            size: 26.r,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: widget.primaryColor.withAlpha(30),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 7.r,
                                height: 7.r,
                                decoration: BoxDecoration(
                                  color: widget.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                widget.status,
                                style: TextStyle(
                                  color: widget.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 6.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : const Color(0xff20253A),
                      ),
                    ),

                    //SizedBox(height: 10.h),
                    Text(
                      widget.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 6.sp,
                        color: Colors.grey.shade600,
                        height: 1.45,
                      ),
                    ),

                    const Spacer(),

                    if (widget.amount != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(180),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.amount!,
                                style: TextStyle(
                                  color: widget.primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18.r,
                              color: widget.primaryColor,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Due Today",
                              style: TextStyle(
                                color: widget.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 14.h),

                    SizedBox(
                      width: double.infinity,
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          shadowColor: widget.primaryColor.withAlpha(103),
                          backgroundColor: widget.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.buttonText,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: widget.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
