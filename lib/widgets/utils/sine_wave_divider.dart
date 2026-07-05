import 'package:flutter/material.dart';

class WaveDivider extends StatelessWidget {
  final double width;
  final Color color;
  final double thickness;
  final bool rounded;

  const WaveDivider({
    super.key,
    required this.color,
    this.width = double.infinity,
    this.thickness = 8.0,
    this.rounded = true,
  });

  @override
  Widget build(BuildContext context) {
    const double amplitude = 3.0;
    final double computedHeight = (amplitude * 2) + thickness;

    return SizedBox(
      width: width,
      height: computedHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final drawWidth = width == double.infinity ? constraints.maxWidth : width;

          return CustomPaint(
            size: Size(drawWidth, computedHeight),
            painter: _BezierWavePainter(
              color: color,
              thickness: thickness,
              rounded: rounded,
              amplitude: amplitude,
            ),
          );
        },
      ),
    );
  }
}

class _BezierWavePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool rounded;
  final double amplitude;
  final double wavelength = 40.0;

  _BezierWavePainter({
    required this.color,
    required this.thickness,
    required this.rounded,
    required this.amplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = rounded ? StrokeCap.round : StrokeCap.butt;

    var baseWavePath = Path()..moveTo(0.0, 0.0);
    final halfWavelength = wavelength / 2.0;

    var anchorX = halfWavelength;
    var controlX = halfWavelength / 2.0;
    var controlY = amplitude * 2.0;

    final targetLength = size.width + wavelength;

    while (anchorX <= targetLength) {
      baseWavePath.quadraticBezierTo(controlX, controlY, anchorX, 0.0);
      anchorX += halfWavelength;
      controlX += halfWavelength;
      controlY = -controlY;
    }

    final centerMatrix = Matrix4.identity()..translate(0.0, size.height / 2.0);
    baseWavePath = baseWavePath.transform(centerMatrix.storage);

    final metrics = baseWavePath.computeMetrics();
    final boundsWidth = baseWavePath.getBounds().width;

    if (boundsWidth <= 0) return;

    // Using a loop completely avoids the `.first` crash risk
    for (final metric in metrics) {
      final scale = metric.length / boundsWidth;
      final visibleSegment = metric.extractPath(0.0, size.width * scale, startWithMoveTo: true);
      canvas.drawPath(visibleSegment, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BezierWavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.rounded != rounded;
  }
}

class AnimatedWaveDivider extends StatefulWidget {
  final double width;
  final Color color;
  final double thickness;
  final bool rounded;
  final Duration duration;

  const AnimatedWaveDivider({
    super.key,
    required this.color,
    this.width = double.infinity,
    this.thickness = 8.0,
    this.rounded = true,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedWaveDivider> createState() => _AnimatedWaveDividerState();
}

class _AnimatedWaveDividerState extends State<AnimatedWaveDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double amplitude = 3.0;
    final double computedHeight = (amplitude * 2) + widget.thickness;

    return SizedBox(
      width: widget.width,
      height: computedHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final drawWidth = widget.width == double.infinity ? constraints.maxWidth : widget.width;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(drawWidth, computedHeight),
                painter: _AnimatedBezierWavePainter(
                  color: widget.color,
                  thickness: widget.thickness,
                  rounded: widget.rounded,
                  amplitude: amplitude,
                  waveOffset: _controller.value,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimatedBezierWavePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool rounded;
  final double amplitude;
  final double waveOffset;
  final double wavelength = 40.0;

  _AnimatedBezierWavePainter({
    required this.color,
    required this.thickness,
    required this.rounded,
    required this.amplitude,
    required this.waveOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = rounded ? StrokeCap.round : StrokeCap.butt;

    var baseWavePath = Path()..moveTo(0.0, 0.0);
    final halfWavelength = wavelength / 2.0;

    var anchorX = halfWavelength;
    var controlX = halfWavelength / 2.0;
    var controlY = amplitude * 2.0;

    final extraPhaseWidth = size.width + (wavelength * 2.0);

    while (anchorX <= extraPhaseWidth) {
      baseWavePath.quadraticBezierTo(controlX, controlY, anchorX, 0.0);
      anchorX += halfWavelength;
      controlX += halfWavelength;
      controlY = -controlY;
    }

    final centerMatrix = Matrix4.identity()..translate(0.0, size.height / 2.0);
    baseWavePath = baseWavePath.transform(centerMatrix.storage);

    final metrics = baseWavePath.computeMetrics();
    final boundsWidth = baseWavePath.getBounds().width;

    if (boundsWidth <= 0) return;

    // Safe iteration over metrics
    for (final metric in metrics) {
      final scale = metric.length / boundsWidth;
      final shiftPixels = waveOffset * wavelength;

      var activeSegment = metric.extractPath(
        shiftPixels * scale,
        (size.width + shiftPixels) * scale,
        startWithMoveTo: true,
      );

      final correctionMatrix = Matrix4.identity()..translate(-shiftPixels, 0.0);
      activeSegment = activeSegment.transform(correctionMatrix.storage);

      canvas.drawPath(activeSegment, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedBezierWavePainter oldDelegate) {
    return oldDelegate.waveOffset != waveOffset ||
        oldDelegate.color != color ||
        oldDelegate.thickness != thickness ||
        oldDelegate.rounded != rounded;
  }
}
