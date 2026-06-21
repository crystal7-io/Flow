import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/utils/avatar_shape.dart';
import 'package:redesigned/widgets/profile_picture_viewer_model.dart';
import 'package:redesigned/widgets/utils/m3expressive/button_group.dart';

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
                  backgroundColor: colorScheme.surfaceContainer.withValues(alpha: animation.value),
                  body: Stack(
                    children: [
                      child!,
                      Positioned(
                        top: MediaQuery.of(context).viewPadding.top + 16,
                        right: 16,
                        left: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StaggeredBubble(
                              animation: closeButtonAnim,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(Symbols.arrow_back, weight: 800),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            _StaggeredBubble(
                              animation: closeButtonAnim,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: const Icon(Symbols.more_vert, weight: 800),
                                onPressed: () {},
                              ),
                            ),
                          ],
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
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Hero(
                        tag: 'pfp_${post.postId}',
                        createRectTween: (begin, end) =>
                            ExpressiveRectTween(begin: begin, end: end),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(
                            MediaQuery.widthOf(context) / 4,
                          ),
                          child: SizedBox(
                            height: MediaQuery.widthOf(context) / 1.5,
                            width: MediaQuery.widthOf(context),
                            child: CachedNetworkImage(
                              // color: colorScheme.primary,
                              // colorBlendMode: BlendMode.modulate,
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              placeholderFadeInDuration: const Duration(seconds: 0),
                              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(value: downloadProgress.progress),
                              ),
                              fit: BoxFit.cover,
                              imageUrl: post.person.pfpPath,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
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

    // final profileAnim = CurvedAnimation(
    //   parent: animation,
    //   curve: const Interval(0.90, 1.0, curve: Easing.emphasizedDecelerate),
    // );
    final followingAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.85, 0.97, curve: Easing.emphasizedDecelerate),
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
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 64),
            child: SizedBox(
              width: MediaQuery.widthOf(context) - 48,
              child: FittedBox(
                child: Text(
                  post.person.name,
                  style: TextStyle(
                    fontFamily: 'Google Sans Flex',
                    fontSize: 60,
                    color: colorScheme.primary,
                    fontVariations: [FontVariation.weight(1000.0), FontVariation.width(10)],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _StaggeredBubble(
          animation: nameAnim,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Text(
              '❝Everyone have freedom of thought❞',
              textAlign: .center,
              style: GoogleFonts.petitFormalScript(
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        // Action Buttons
        _StaggeredBubble(
          alignment: Alignment.center,
          animation: followingAnim,
          child: StandardButtonGroup(
            spacing: 4,
            alignment: MainAxisAlignment.center,
            items: [
              ButtonGroupItem(
                roundBorder: !model.isFollowing,
                width: MediaQuery.widthOf(context) - 148,
                backgroundColor: model.isFollowing
                    ? colorScheme.surfaceContainerLowest
                    : colorScheme.tertiary,
                foregroundColor: model.isFollowing ? colorScheme.primary : colorScheme.onTertiary,
                height: 64,
                icon: model.isFollowing ? Symbols.done : Symbols.add,
                onPressed: model.toggleFollowing,
                label: Text(
                  model.isFollowing ? "Following" : "Follow",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              ButtonGroupItem(
                width: 72,
                height: 64,
                onPressed: model.toggleStar,
                icon: model.isStarred ? Icons.star : Symbols.star_outline,
                foregroundColor: model.isStarred
                    ? colorScheme.onSecondaryContainer
                    : colorScheme.onPrimaryContainer,
                backgroundColor: model.isStarred
                    ? colorScheme.surfaceContainerLowest
                    : colorScheme.primaryContainer,
              ),
              ButtonGroupItem(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                width: 48,
                height: 64,
                onPressed: () {},
                icon: Symbols.message,
              ),
              // ButtonGroupItem(
              //   backgroundColor: colorScheme.tertiaryContainer,
              //   foregroundColor: colorScheme.onTertiaryContainer,
              //   width: 56,
              //   height: 72,
              //   onPressed: () {},
              //   icon: Symbols.forward,
              // ),
            ],
          ),
        ),

        // Row(
        //   children: [
        //     Expanded(
        //       child: _StaggeredBubble(
        //         animation: followingAnim,
        //         alignment: Alignment.center,
        //         child: SizedBox(
        //           height: 72,
        //           child: FilledButton.icon(
        //             icon: Icon(
        //               model.isFollowing ? Symbols.done : Symbols.add,
        //               size: 24,
        //               weight: 800,
        //             ),
        //             label: Text(
        //               model.isFollowing ? "Followed" : "Follow",
        //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        //             ),
        //             style: ButtonStyle(
        //               shape: WidgetStatePropertyAll(
        //                 model.isFollowing
        //                     ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
        //                     : StadiumBorder(),
        //               ),
        //               foregroundColor: WidgetStatePropertyAll(
        //                 model.isFollowing
        //                     ? colorScheme.onSecondaryContainer
        //                     : colorScheme.onSecondary,
        //               ),
        //               backgroundColor: WidgetStatePropertyAll(
        //                 model.isFollowing ? colorScheme.secondaryContainer : colorScheme.primary,
        //               ),
        //             ),
        //             onPressed: model.toggleFollowing,
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 4),
        //     _StaggeredBubble(
        //       animation: profileAnim,
        //       alignment: Alignment.center,
        //       child: SizedBox(
        //         height: 72,
        //         child: ExpressiveSpringIconButton(
        //           unselectedBg: colorScheme.tertiaryContainer,
        //           unselectedContent: colorScheme.onTertiaryContainer,
        //           icon: model.isStarred ? Icons.star : Icons.star_outline,
        //           selectedBg: colorScheme.surfaceBright,
        //           selectedContent: colorScheme.onSurface,
        //           unselectedLength: 64,
        //           selectedLength: 78,
        //           isSelected: model.isStarred,
        //           onTap: model.toggleStar,
        //         ),
        //       ),
        //     ),

        //   ],
        // ),
        const SizedBox(height: 16),

        // _HorizontalReveal(
        //   animation: svgRevealAnim,
        //   child: SvgPicture.asset(
        //     "assets/zigzag.svg",
        //     colorFilter: ColorFilter.mode(colorScheme.onSecondaryContainer, BlendMode.srcIn),
        //   ),
        // ),
        SizedBox(
          width: MediaQuery.widthOf(context) - 100,
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatPill(
                  context,
                  icon: Icons.groups_rounded,
                  value: "243K",
                  label: "Followers",
                  animation: followersAnim,
                  colorScheme: colorScheme,
                ),
                SizedBox(width: MediaQuery.widthOf(context) / 4),
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
          ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.limelight(
              fontSize: 64,
              height: 1,
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.googleSansCode(
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
              fontSize: 24,
            ),
          ),
        ],
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
