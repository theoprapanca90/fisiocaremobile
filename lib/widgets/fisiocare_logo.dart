import 'package:flutter/material.dart';
import '../theme.dart';

class FisioCareLogoWidget extends StatelessWidget {
  const FisioCareLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FisioCareLogoPainter(),
    );
  }
}

class _FisioCareLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background circle (teal)
    final bgPaint = Paint()
      ..color = const Color(0xFF00BBA7)
      ..style = PaintingStyle.fill;

    // Draw house outline
    final housePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // House body
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.15, size.height * 0.52);
    bodyPath.lineTo(size.width * 0.15, size.height * 0.88);
    bodyPath.lineTo(size.width * 0.85, size.height * 0.88);
    bodyPath.lineTo(size.width * 0.85, size.height * 0.52);
    bodyPath.close();
    canvas.drawPath(bodyPath, housePaint);

    // Roof
    final roofPath = Path();
    roofPath.moveTo(size.width * 0.05, size.height * 0.52);
    roofPath.lineTo(size.width * 0.5, size.height * 0.1);
    roofPath.lineTo(size.width * 0.95, size.height * 0.52);
    roofPath.close();
    canvas.drawPath(roofPath, housePaint);

    // Medical cross (white)
    final crossPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final crossW = size.width * 0.08;
    final crossH = size.height * 0.26;
    final cx = size.width * 0.5;
    final cy = size.height * 0.68;

    // Horizontal
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: crossH, height: crossW),
        const Radius.circular(2),
      ),
      crossPaint,
    );

    // Vertical
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: crossW, height: crossH),
        const Radius.circular(2),
      ),
      crossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FisioCareLogoSmall extends StatelessWidget {
  const FisioCareLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: FisioCareLogoWidget(),
      ),
    );
  }
}
