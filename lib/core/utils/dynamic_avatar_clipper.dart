import 'package:flutter/material.dart';
import 'package:redesigned/core/utils/m3_shape_cache.dart';

class DynamicAvatarClipper extends CustomClipper<Path> {
  final String shapeKey;

  DynamicAvatarClipper(this.shapeKey);

  @override
  Path getClip(Size size) {
    return M3ShapeCache.getScaledPath(shapeKey: shapeKey, width: size.width, height: size.height);
  }

  @override
  bool shouldReclip(covariant DynamicAvatarClipper oldClipper) {
    return oldClipper.shapeKey != shapeKey;
  }
}
