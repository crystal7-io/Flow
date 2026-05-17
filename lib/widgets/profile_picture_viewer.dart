import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/widgets/utils/m3expressive/expressive_button.dart';

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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor:
              theme.colorScheme.surface.withValues(alpha: animation.value),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: child,
        );
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Hero(
                tag: 'pfp_${post.postId}',
                createRectTween: (begin, end) =>
                    ExpressiveRectTween(begin: begin, end: end),
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: MaterialShapes.pentagon(
                        color: Colors.transparent,
                        size: size.width - 120,
                        imageFit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          post.person.pfpPath,
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildMetadata(context, animation),
            // Room for more content later
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Animation<double> animation) {
    // Staggered timing for a high-end feel
    final nameAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.80, 0.95, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.20, 0.30, curve: Easing.standardAccelerate),
    );
    final followingAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.85, 0.97, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.15, 0.25, curve: Easing.standardAccelerate),
    );
    final profileAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.90, 1.0, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.05, 0.15, curve: Easing.standardAccelerate),
    );

    return Column(
      children: [
        // Name and Username
        _StaggeredBubble(
          animation: nameAnim,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(
                post.person.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                post.person.userName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: _StaggeredBubble(
                animation: followingAnim,
                alignment: Alignment.center,
                child: ExpressiveButton(
                  height: 64,
                  isSelected: false,
                  persistText: true,
                  icon: Icons.done,
                  onTap: () {},
                  text: "Following",
                ),
              )),
              _StaggeredBubble(
                  animation: profileAnim,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 56,
                    child: ExpressiveButton(
                      height: 64,
                      isSelected: false,
                      onTap: () {},
                      icon: Icons.star_outline,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _StaggeredBubble extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;

  const _StaggeredBubble({
    required this.animation,
    required this.child,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          alignment: alignment,
          child: child,
        );
      },
      child: child,
    );
  }
}

class _ActionBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  const _ActionBubble({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 64,
        child: FilledButton.icon(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
          ),
          onPressed: () {},
          icon: Icon(icon, color: textColor, size: 18),
          label: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ));
  }
}
