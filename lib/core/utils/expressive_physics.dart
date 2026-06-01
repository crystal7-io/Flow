import 'package:flutter/physics.dart';
import 'dart:math' as math;

class ExpressivePhysics {
  // Prevent instantiation
  ExpressivePhysics._();

  // Helper to calculate damping coefficient (c) from damping ratio (zeta)
  static double _calculateDamping(double mass, double stiffness, double zeta) {
    return 2 * zeta * math.sqrt(mass * stiffness);
  }

  // --- Spatial Configs (With Overshoot/Bounce: Zeta = 0.65) ---

  /// Expressive Fast Spatial: High stiffness, low damping ratio for quick bounce.
  static final SpringDescription expressiveFastSpatial = SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: _calculateDamping(1.0, 300.0, 0.65),
  );

  /// Expressive Default Spatial: Medium stiffness, balanced organic bounce.
  static final SpringDescription expressiveDefaultSpatial = SpringDescription(
    mass: 1.0,
    stiffness: 150.0,
    damping: _calculateDamping(1.0, 150.0, 0.65),
  );

  /// Expressive Slow Spatial: Low stiffness, gentle fluid bounce.
  static final SpringDescription expressiveSlowSpatial = SpringDescription(
    mass: 1.0,
    stiffness: 80.0,
    damping: _calculateDamping(1.0, 80.0, 0.65),
  );

  // --- Effects Configs (No Overshoot: Zeta = 1.0) ---

  /// Expressive Fast Effects: Snappy transition without overshoot.
  static final SpringDescription expressiveFastEffects = SpringDescription(
    mass: 1.0,
    stiffness: 400.0,
    damping: _calculateDamping(1.0, 400.0, 1.0),
  );

  /// Expressive Default Effects: Smooth transition without overshoot.
  static final SpringDescription expressiveDefaultEffects = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: _calculateDamping(1.0, 200.0, 1.0),
  );

  /// Expressive Slow Effects: Deliberate, gradual transition without overshoot.
  static final SpringDescription expressiveSlowEffects = SpringDescription(
    mass: 1.0,
    stiffness: 100.0,
    damping: _calculateDamping(1.0, 100.0, 1.0),
  );
}
