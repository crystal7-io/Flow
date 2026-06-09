import 'package:flutter/physics.dart';

class ExpressiveMotionSpring {
  // Prevent instantiation
  ExpressiveMotionSpring._();

  static final SpringDescription fastSpatial =
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 800.0,
        ratio: 0.6,
      );

  static final SpringDescription defaultSpatial =
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 380.0,
        ratio: 0.8,
      );

  static final SpringDescription slowSpatial =
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 200.0,
        ratio: 0.8,
      );

  static final SpringDescription fastEffects =
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 3800.0,
        ratio: 1,
      );

  static final SpringDescription defaultEffects =
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 1600.0,
        ratio: 1,
      );

  static final SpringDescription slowEffects =
      SpringDescription.withDampingRatio(mass: 1.0, stiffness: 800.0, ratio: 1);
}
