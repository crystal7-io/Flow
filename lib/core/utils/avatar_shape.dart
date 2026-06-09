import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom shape that creates a rounded polygon (blob) with a specified
/// number of points and roundness.
///
/// This shape scales its corner radius relative to its size, ensuring the
/// aesthetic remains consistent across different scales, unlike fixed-radius
/// shapes.
class BlobShape extends ShapeBorder {
  final int points;
  final double roundness;
  final double rotation;

  const BlobShape({this.points = 5, this.roundness = 0.6, this.rotation = 0.0});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final double size = math.min(rect.width, rect.height);
    final double radius = size / 2;
    final Offset center = rect.center;
    final Path path = Path();

    if (points < 3) return path..addOval(rect);

    final double step = 2 * math.pi / points;
    final List<Offset> vertices = [];

    for (int i = 0; i < points; i++) {
      final double theta = -math.pi / 2 + i * step + rotation;
      vertices.add(
        Offset(
          center.dx + radius * math.cos(theta),
          center.dy + radius * math.sin(theta),
        ),
      );
    }

    // Calculate a corner radius that scales with the size
    final double sideLength = (vertices[1] - vertices[0]).distance;
    final double cornerRadius = sideLength * (roundness / 2);

    for (int i = 0; i < points; i++) {
      final Offset p1 = vertices[(i - 1 + points) % points];
      final Offset p2 = vertices[i];
      final Offset p3 = vertices[(i + 1) % points];

      final double dist12 = (p2 - p1).distance;
      final double dist23 = (p3 - p2).distance;

      final double actualK = math.min(
        cornerRadius,
        math.min(dist12, dist23) / 2,
      );

      final Offset start = p2 + (p1 - p2) * (actualK / dist12);
      final Offset end = p2 + (p3 - p2) * (actualK / dist23);

      if (i == 0) {
        path.moveTo(start.dx, start.dy);
      } else {
        // Instead of lineTo, we can use a slight curve for the "sides"
        // to make it more blobby/organic
        final Offset prevEnd = _getEndForIndex(
          (i - 1 + points) % points,
          vertices,
          cornerRadius,
        );
        final double sideDist = (start - prevEnd).distance;
        if (sideDist > 0) {
          final Offset cp = Offset.lerp(prevEnd, start, 0.5)!;
          // Pull the side slightly outwards
          final Offset normal =
              _getNormal(prevEnd, start) * (sideDist * 0.1 * roundness);
          path.quadraticBezierTo(
            cp.dx + normal.dx,
            cp.dy + normal.dy,
            start.dx,
            start.dy,
          );
        } else {
          path.lineTo(start.dx, start.dy);
        }
      }

      // Use cubic beziers for smoother "blobby" corners
      final double controlDist = actualK * 0.552284749831;
      final Offset cp1 = p2 + (p1 - p2) * ((actualK - controlDist) / dist12);
      final Offset cp2 = p2 + (p3 - p2) * ((actualK - controlDist) / dist23);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);
    }

    path.close();
    return path;
  }

  Offset _getEndForIndex(int i, List<Offset> vertices, double cornerRadius) {
    final Offset p2 = vertices[i];
    final Offset p3 = vertices[(i + 1) % vertices.length];
    final double dist23 = (p3 - p2).distance;
    final double actualK = math.min(cornerRadius, dist23 / 2);
    return p2 + (p3 - p2) * (actualK / dist23);
  }

  Offset _getNormal(Offset p1, Offset p2) {
    final Offset dir = p2 - p1;
    final double len = dir.distance;
    if (len == 0) return Offset.zero;
    return Offset(dir.dy / len, -dir.dx / len);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) =>
      BlobShape(points: points, roundness: roundness * t, rotation: rotation);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BlobShape) return false;
    return other.points == points &&
        other.roundness == roundness &&
        other.rotation == rotation;
  }

  @override
  int get hashCode => Object.hash(points, roundness, rotation);
}

/// A clipper that uses [BlobShape] to clip a widget.
class BlobClipper extends CustomClipper<Path> {
  final int points;
  final double roundness;
  final double rotation;

  BlobClipper({this.points = 5, this.roundness = 0.6, this.rotation = 0.0});

  @override
  Path getClip(Size size) {
    return BlobShape(
      points: points,
      roundness: roundness,
      rotation: rotation,
    ).getOuterPath(Offset.zero & size);
  }

  @override
  bool shouldReclip(covariant BlobClipper oldClipper) {
    return oldClipper.points != points ||
        oldClipper.roundness != roundness ||
        oldClipper.rotation != rotation;
  }
}

/// A widget that clips its child into a blob shape, perfect for avatars.
class BlobAvatar extends StatelessWidget {
  final Widget child;
  final double? size;
  final int points;
  final double roundness;
  final double rotation;
  final Color? paddingColor;
  final double padding;

  const BlobAvatar({
    super.key,
    required this.child,
    this.size,
    this.points = 5,
    this.roundness = 0.6,
    this.rotation = 0.0,
    this.paddingColor,
    this.padding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ClipPath(
      clipper: BlobClipper(
        points: points,
        roundness: roundness,
        rotation: rotation,
      ),
      child: child,
    );

    if (padding > 0) {
      content = Container(
        padding: EdgeInsets.all(padding),
        decoration: ShapeDecoration(
          color: paddingColor ?? Theme.of(context).colorScheme.surface,
          shape: BlobShape(
            points: points,
            roundness: roundness,
            rotation: rotation,
          ),
        ),
        child: content,
      );
    }

    if (size != null) {
      return SizedBox(width: size, height: size, child: content);
    }

    return content;
  }
}
