import 'package:flutter/material.dart';
import 'package:androidx_graphics_shapes/material_shapes.dart';
import 'package:androidx_graphics_shapes/shapes.dart';

class M3ShapeCache {
  // Global cache holding paths mapped by "shapeKey_width_height"
  static final Map<String, Path> _pathCache = {};

  /// Returns a pre-computed or freshly generated path scaled to the target bounds.
  static Path getScaledPath({
    required String shapeKey,
    required double width,
    required double height,
  }) {
    final String cacheKey = '${shapeKey}_${width.toInt()}_${height.toInt()}';

    if (_pathCache.containsKey(cacheKey)) {
      return _pathCache[cacheKey]!;
    }

    final RoundedPolygon polygon = _getShapeByKey(shapeKey);
    final Path basePath = polygon.toPath();
    final Rect pathBounds = basePath.getBounds();

    // 1. Calculate separate scales for width and height
    final double scaleX = width / pathBounds.width;
    final double scaleY = height / pathBounds.height;

    // 2. Use the smaller scale factor for BOTH axes to prevent stretching/distortion
    final double uniformScale = scaleX < scaleY ? scaleX : scaleY;

    // 3. Center the path inside the destination box bounds
    final double offsetX = (width - (pathBounds.width * uniformScale)) / 2;
    final double offsetY = (height - (pathBounds.height * uniformScale)) / 2;

    final Matrix4 matrix = Matrix4.identity()
      ..translate(offsetX, offsetY) // 3. Center it
      ..scale(uniformScale, uniformScale) // 2. Scale uniformly
      ..translate(-pathBounds.left, -pathBounds.top); // 1. Zero out original offset

    final computedPath = basePath.transform(matrix.storage);
    _pathCache[cacheKey] = computedPath;
    return computedPath;
  }

  static RoundedPolygon _getShapeByKey(String key) {
    switch (key) {
      case 'circle':
        return MaterialShapes.circle;
      case 'square':
        return MaterialShapes.square;
      case 'slanted':
        return MaterialShapes.slanted;
      case 'arch':
        return MaterialShapes.arch;
      case 'fan':
        return MaterialShapes.fan;
      case 'arrow':
        return MaterialShapes.arrow;
      case 'semiCircle':
        return MaterialShapes.semiCircle;
      case 'oval':
        return MaterialShapes.oval;
      case 'pill':
        return MaterialShapes.pill;
      case 'triangle':
        return MaterialShapes.triangle;
      case 'diamond':
        return MaterialShapes.diamond;
      case 'clamShell':
        return MaterialShapes.clamShell;
      case 'pentagon':
        return MaterialShapes.pentagon;
      case 'gem':
        return MaterialShapes.gem;
      case 'verySunny':
        return MaterialShapes.verySunny;
      case 'sunny':
        return MaterialShapes.sunny;
      case 'cookie4Sided':
        return MaterialShapes.cookie4Sided;
      case 'cookie6Sided':
        return MaterialShapes.cookie6Sided;
      case 'cookie7Sided':
        return MaterialShapes.cookie7Sided;
      case 'cookie9Sided':
        return MaterialShapes.cookie9Sided;
      case 'cookie12Sided':
        return MaterialShapes.cookie12Sided;
      case 'ghostish':
        return MaterialShapes.ghostish;
      case 'clover4Leaf':
        return MaterialShapes.clover4Leaf;
      case 'clover8Leaf':
        return MaterialShapes.clover8Leaf;
      case 'burst':
        return MaterialShapes.burst;
      case 'softBurst':
        return MaterialShapes.softBurst;
      case 'boom':
        return MaterialShapes.boom;
      case 'softBoom':
        return MaterialShapes.softBoom;
      case 'flower':
        return MaterialShapes.flower;
      case 'puffy':
        return MaterialShapes.puffy;
      case 'puffyDiamond':
        return MaterialShapes.puffyDiamond;
      case 'pixelCircle':
        return MaterialShapes.pixelCircle;
      case 'pixelTriangle':
        return MaterialShapes.pixelTriangle;
      case 'bun':
        return MaterialShapes.bun;
      case 'heart':
        return MaterialShapes.heart;
      default:
        return MaterialShapes.circle;
    }
  }
}
