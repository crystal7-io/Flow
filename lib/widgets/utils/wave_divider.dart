import 'package:flutter/material.dart';

class WavyDivider extends StatelessWidget {
  final Color? color;
  final double thickness;

  const WavyDivider({
    super.key,
    this.color, // Replace with your primary theme color
    this.thickness = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      height: 9,
      child: CustomPaint(
        painter: _WavyPainter(
          color: color ?? Theme.of(context).colorScheme.outlineVariant,
          thickness: thickness,
        ),
      ),
    );
  }
}

class _WavyPainter extends CustomPainter {
  final Color color;
  final double thickness;

  _WavyPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Starting point corresponding to M1.5 4.5
    double startX = 1.5;
    double startY = 4.5;
    path.moveTo(startX, startY);

    // Wave parameters extracted from the SVG pattern:
    // Wave width (period) is 15.2, peak height variation is 4.667
    const double waveWidth = 15.2;
    const double controlX = 5.067;
    const double controlY = 4.667;

    // Loop to fill the width of the canvas dynamically
    while (startX < size.width) {
      // First half-wave (crest)
      path.cubicTo(
        startX + controlX,
        startY - controlY,
        startX + waveWidth - controlX,
        startY - controlY,
        startX + waveWidth,
        startY,
      );

      // Second half-wave (trough)
      path.cubicTo(
        startX + waveWidth + controlX,
        startY + controlY,
        startX + (2 * waveWidth) - controlX,
        startY + controlY,
        startX + (2 * waveWidth),
        startY,
      );

      startX += 2 * waveWidth;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.thickness != thickness;
  }
}
