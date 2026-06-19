import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/utils/avatar_shape.dart';
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

  const ProfilePictureViewer({super.key, required this.post, required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final closeButtonAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.96, 1.0, curve: Easing.emphasizedDecelerate),
    );
    return ChangeNotifierProvider(
      create: (context) {
        final model = ProfilePictureViewerModel();
        model.extractColors(post.person.pfpPath, theme.brightness);
        return model;
      },
      child: Consumer<ProfilePictureViewerModel>(
        builder: (context, model, child) {
          final colorScheme = model.colorScheme ?? theme.colorScheme;
          return Theme(
            data: theme.copyWith(colorScheme: colorScheme),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Scaffold(
                  backgroundColor: colorScheme.surface.withValues(alpha: animation.value),
                  body: Stack(
                    children: [
                      child!,
                      Positioned(
                        top: MediaQuery.of(context).viewPadding.top + 16,
                        right: 16,
                        child: _StaggeredBubble(
                          animation: closeButtonAnim,
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 48,
                            width: 56,
                            child: IconButton(
                              style: ButtonStyle(
                                iconColor: WidgetStatePropertyAll(colorScheme.onSurfaceVariant),
                                backgroundColor: WidgetStatePropertyAll(
                                  colorScheme.surfaceContainerHigh,
                                ),
                              ),
                              icon: const Icon(Symbols.close, weight: 800),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Hero(
                      tag: 'pfp_${post.postId}',
                      createRectTween: (begin, end) => ExpressiveRectTween(begin: begin, end: end),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: BlobAvatar(
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            placeholderFadeInDuration: const Duration(seconds: 0),
                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(value: downloadProgress.progress),
                            ),
                            fit: BoxFit.contain,
                            imageUrl: post.person.pfpPath,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMetadata(context, animation, model, colorScheme),
                    // Room for more content later
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadata(
    BuildContext context,
    Animation<double> animation,
    ProfilePictureViewerModel model,
    ColorScheme colorScheme,
  ) {
    // Staggered timing for a high-end feel
    final nameAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.80, 0.95, curve: Easing.emphasizedDecelerate),
    );
    final followingAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.85, 0.97, curve: Easing.emphasizedDecelerate),
    );
    final profileAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.90, 1.0, curve: Easing.emphasizedDecelerate),
    );
    final followersAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.92, 1.0, curve: Easing.emphasizedDecelerate),
    );
    final followingAnimStat = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.94, 1.0, curve: Easing.emphasizedDecelerate),
    );
    final svgRevealAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.94, 1.0, curve: Easing.standardDecelerate),
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
                style: GoogleFonts.permanentMarker(
                  textStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.person.userName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _StaggeredBubble(
                  animation: followingAnim,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 72,
                    child: FilledButton.icon(
                      icon: Icon(
                        model.isFollowing ? Symbols.done : Symbols.add,
                        size: 24,
                        weight: 800,
                      ),
                      label: Text(
                        model.isFollowing ? "Followed" : "Follow",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          model.isFollowing
                              ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
                              : StadiumBorder(),
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          model.isFollowing
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onPrimary,
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          model.isFollowing ? colorScheme.secondaryContainer : colorScheme.primary,
                        ),
                      ),
                      onPressed: model.toggleFollowing,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _StaggeredBubble(
                animation: profileAnim,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 72,
                  child: ExpressiveSpringIconButton(
                    unselectedBg: colorScheme.tertiaryContainer,
                    unselectedContent: colorScheme.onTertiaryContainer,
                    selectedBg: colorScheme.surfaceContainerHighest,
                    selectedContent: colorScheme.onSurface,
                    unselectedLength: 64,
                    selectedLength: 78,
                    isSelected: model.isStarred,
                    onTap: model.toggleStar,
                    icon: model.isStarred ? Icons.star : Icons.star_outline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        _HorizontalReveal(
          animation: svgRevealAnim,
          child: SvgPicture.asset(
            "assets/zigzag.svg",
            colorFilter: ColorFilter.mode(colorScheme.outlineVariant, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatPill(
              context,
              icon: Icons.groups_rounded,
              value: "2.4K",
              label: "Followers",
              animation: followersAnim,
              colorScheme: colorScheme,
            ),
            _buildStatPill(
              context,
              icon: Icons.person_add_rounded,
              value: "140",
              label: "Following",
              animation: followingAnimStat,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatPill(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Animation<double> animation,
    required ColorScheme colorScheme,
  }) {
    return _StaggeredBubble(
      animation: animation,
      alignment: Alignment.center,
      child: Material(
        color: colorScheme.surface,
        shape: const StadiumBorder(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.limelight(
                textStyle: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredBubble extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Alignment alignment;

  const _StaggeredBubble({required this.animation, required this.child, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(scale: animation.value, alignment: alignment, child: child);
      },
      child: child,
    );
  }
}

class _HorizontalReveal extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _HorizontalReveal({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipRect(
          child: Align(alignment: Alignment.center, widthFactor: animation.value, child: child),
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
