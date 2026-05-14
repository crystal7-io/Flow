import 'package:flutter/animation.dart';

class CustomCurves {
  static const Curve expressiveFastSpatial = Cubic(0.42, 1.67, 0.21, 0.90);
  static const Curve expressiveSlowSpatial = Cubic(0.39, 1.29, 0.35, 0.98);
  static const Curve expressiveDefaultSpatial = Cubic(0.38, 1.21, 0.22, 1.00);
  static const Curve emphasizedDecel = Cubic(0.05, 0.7, 0.1, 1);
  static const Curve emphasizedAccel = Cubic(0.3, 0, 0.8, 0.15);
  static const Curve standardDecel = Cubic(0, 0, 0, 1);
  static const Curve menuDecel = Cubic(0.1, 1, 0, 1);
  static const Curve menuAccel = Cubic(0.52, 0.03, 0.72, 0.08);
  static const Curve stall = Cubic(1, -0.1, 0.7, 0.85);
}
