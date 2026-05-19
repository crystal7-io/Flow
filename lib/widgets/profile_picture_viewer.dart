import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/widgets/profile_picture_viewer_model.dart';
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

    return ChangeNotifierProvider(
      create: (context) => ProfilePictureViewerModel(),
      child: Consumer<ProfilePictureViewerModel>(
        builder: (context, model, child) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Scaffold(
                backgroundColor: theme.colorScheme.surface
                    .withValues(alpha: animation.value),
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
                  _buildMetadata(context, animation, model),
                  // Room for more content later
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadata(BuildContext context, Animation<double> animation,
      ProfilePictureViewerModel model) {
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
    final followersAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.92, 1.0, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.02, 0.12, curve: Easing.standardAccelerate),
    );
    final followingAnimStat = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.94, 1.0, curve: Easing.emphasizedDecelerate),
      reverseCurve: const Interval(0.0, 0.10, curve: Easing.standardAccelerate),
    );
    final svgRevealAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.75, 0.90, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.25, 0.35, curve: Easing.standardAccelerate),
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
          child: Wrap(
            children: [
              _StaggeredBubble(
                animation: followingAnim,
                alignment: Alignment.center,
                child: ExpressiveButton(
                  height: 64,
                  unselectedLength: MediaQuery.of(context).size.width - 248,
                  isSelected: model.isFollowing,
                  persistText: true,
                  icon: Icons.done,
                  onTap: model.toggleFollowing,
                  text: "Following",
                  textStyle: GoogleFonts.manrope(fontSize: 14),
                ),
              ),
              SizedBox(width: 4),
              _StaggeredBubble(
                animation: profileAnim,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 64,
                  child: ExpressiveIconButton(
                    unselectedLength: 58,
                    selectedLength: 72,
                    isSelected: model.isStarred,
                    onTap: model.toggleStar,
                    icon: model.isStarred ? Icons.star : Icons.star_outline,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 28),
        _HorizontalReveal(
          animation: svgRevealAnim,
          child: SvgPicture.asset("assets/zigzag.svg"),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatPill(
              context,
              icon: Icons.groups_rounded,
              value: "24K",
              label: "Followers",
              animation: followersAnim,
            ),
            const SizedBox(width: 12),
            _buildStatPill(
              context,
              icon: Icons.person_add_rounded,
              value: "14",
              label: "Following",
              animation: followingAnimStat,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Animation<double> animation,
  }) {
    final theme = Theme.of(context);
    return _StaggeredBubble(
      animation: animation,
      alignment: Alignment.center,
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: GoogleFonts.audiowide(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
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

class _HorizontalReveal extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _HorizontalReveal({
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// class _ActionBubble extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color backgroundColor;
//   final Color textColor;

//   const _ActionBubble({
//     required this.label,
//     required this.icon,
//     required this.backgroundColor,
//     required this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 64,
//         child: FilledButton.icon(
//           style: ButtonStyle(
//             backgroundColor: WidgetStatePropertyAll(backgroundColor),
//           ),
//           onPressed: () {},
//           icon: Icon(icon, color: textColor, size: 18),
//           label: Text(
//             label,
//             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                   color: textColor,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//           ),
//         ));
//   }
// }
