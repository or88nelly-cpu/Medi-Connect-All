import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class QrCodeDisplay extends StatefulWidget {
  final String registrationId;
  final VoidCallback? onRefresh;

  const QrCodeDisplay({
    super.key,
    required this.registrationId,
    this.onRefresh,
  });

  @override
  State<QrCodeDisplay> createState() => _QrCodeDisplayState();
}

class _QrCodeDisplayState extends State<QrCodeDisplay> {
  int _secondsRemaining = 900; // 15 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant QrCodeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.registrationId != widget.registrationId) {
      _resetTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 900;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.registrationId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registration ID ${widget.registrationId} copied!"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final timerColor = _secondsRemaining > 60
        ? const Color(0xFF4F46E5)
        : Colors.red;

    return Center(
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Frame around QR Code
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Corner brackets
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildCorner(
                      top: true,
                      left: true,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildCorner(
                      top: true,
                      left: false,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _buildCorner(
                      top: false,
                      left: true,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _buildCorner(
                      top: false,
                      left: false,
                      color: AppColors.primary,
                    ),
                  ),

                  // QR Custom Paint
                  Container(
                    width: 200.r,
                    height: 200.r,
                    margin: EdgeInsets.all(8.r),
                    child: CustomPaint(
                      painter: QrCodePainter(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Registration ID Info Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Text(
                    "Registration ID",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.registrationId,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      InkWell(
                        onTap: () => _copyToClipboard(context),
                        borderRadius: BorderRadius.circular(6.r),
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 16.r,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Countdown Timer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded, size: 16.r, color: timerColor),
                SizedBox(width: 6.w),
                Text(
                  _secondsRemaining > 0
                      ? "Valid for ${_formatTime(_secondsRemaining)} minutes"
                      : "QR Expired",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: timerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    required bool top,
    required bool left,
    required Color color,
  }) {
    final double borderW = 3.w;
    final double size = 16.r;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: top ? BorderSide(color: color, width: borderW) : BorderSide.none,
          bottom: !top
              ? BorderSide(color: color, width: borderW)
              : BorderSide.none,
          left: left
              ? BorderSide(color: color, width: borderW)
              : BorderSide.none,
          right: !left
              ? BorderSide(color: color, width: borderW)
              : BorderSide.none,
        ),
      ),
    );
  }
}

// Custom Painter for rendering a high-fidelity QR Code simulation
class QrCodePainter extends CustomPainter {
  final Color color;
  const QrCodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    void drawSquare(double x, double y, double w) {
      canvas.drawRect(Rect.fromLTWH(x, y, w, w), paint);
    }

    void drawFinderPattern(double x, double y, double w) {
      final outer = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final innerBg = Paint()..color = Colors.transparent;
      final innerSquare = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Outer block
      canvas.drawRect(Rect.fromLTWH(x, y, w, w), outer);

      // Draw transparent inner area by using BlendMode.clear or white depending on canvas
      final margin1 = w / 7;
      final clearPaint = Paint()
        ..blendMode = BlendMode.clear
        ..color = Colors.transparent;
      canvas.drawRect(
        Rect.fromLTWH(
          x + margin1,
          y + margin1,
          w - 2 * margin1,
          w - 2 * margin1,
        ),
        clearPaint,
      );

      // Restore blend mode to source and draw inner square
      final margin2 = w * 2 / 7;
      canvas.drawRect(
        Rect.fromLTWH(
          x + margin2,
          y + margin2,
          w - 2 * margin2,
          w - 2 * margin2,
        ),
        innerSquare,
      );
    }

    // Force redraw layout
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final w = size.width;
    final finderSize = w * 0.28;

    // Finder Patterns
    drawFinderPattern(0, 0, finderSize);
    drawFinderPattern(w - finderSize, 0, finderSize);
    drawFinderPattern(0, w - finderSize, finderSize);

    // Random QR Blocks
    final rand = Random(42);
    final gridCount = 20;
    final cellSize = w / gridCount;

    for (int r = 0; r < gridCount; r++) {
      for (int c = 0; c < gridCount; c++) {
        final inTopLeft = r < 6 && c < 6;
        final inTopRight = r < 6 && c >= gridCount - 6;
        final inBottomLeft = r >= gridCount - 6 && c < 6;

        if (inTopLeft || inTopRight || inBottomLeft) continue;

        if (rand.nextBool()) {
          drawSquare(c * cellSize, r * cellSize, cellSize);
        }
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
