import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/models/post.dart';

class ExpressiveRectTween extends MaterialRectArcTween {
  ExpressiveRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    final double curvedT = Easing.emphasizedDecelerate.transform(t);
    return super.lerp(curvedT);
  }
}

class ProfilePictureViewer extends StatelessWidget {
  final Post post;
  final Animation<double> animation;

  const ProfilePictureViewer({
    super.key,
    required this.post,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final blurValue = animation.value * 15.0;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
            child: Container(
              color: Colors.black.withValues(alpha: animation.value * 0.4),
              child: Center(
                child: child,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Hero(
            tag: 'pfp_${post.postId}',
            createRectTween: (begin, end) =>
                ExpressiveRectTween(begin: begin, end: end),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: CachedNetworkImage(
                imageUrl: post.person.pfpPath,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 100),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
