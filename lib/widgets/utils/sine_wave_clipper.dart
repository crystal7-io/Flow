import 'dart:math' as math;
import 'package:flutter/material.dart';

class SineWaveClipper extends CustomClipper<Path> {
  final double amplitude;
  final double frequency;

  SineWaveClipper({
    this.amplitude = 20.0,
    this.frequency = 1.0, // 1.0 means one full sine wave cycle across the width
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);

    // Line to the start of the bottom wave
    path.lineTo(0, size.height - amplitude);

    // Loop through the width to plot the sine wave points
    for (double i = 0; i <= size.width; i++) {
      // Standard sine wave formula: y = sin(x * frequency) * amplitude
      double radians = (i / size.width) * (2 * math.pi) * frequency;
      double y = size.height - amplitude + (math.sin(radians) * amplitude);

      path.lineTo(i, y);
    }

    // Close the path
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant SineWaveClipper oldClipper) {
    return oldClipper.amplitude != amplitude || oldClipper.frequency != frequency;
  }
}
