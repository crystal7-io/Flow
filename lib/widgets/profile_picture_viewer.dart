import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/widgets/profile_picture_viewer_model.dart';

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
    final model = context.watch<ProfilePictureViewerModel>();
    final colorScheme = Theme.of(context).colorScheme;

    final baseOpacity = animation.value * 0.4;
    final bgColor = Color.lerp(
      Colors.black.withValues(alpha: baseOpacity),
      colorScheme.surface.withValues(alpha: animation.value),
      model.expansionProgress,
    );

    return GestureDetector(
      onTap: () {
        if (model.expansionProgress == 0) {
          Navigator.of(context).pop();
        }
      },
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final blurValue =
              (1.0 - model.expansionProgress) * animation.value * 15.0;

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
            child: Container(
              color: bgColor,
              child: child,
            ),
          );
        },
        child: Stack(
          children: [
            NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                if (notification.direction == ScrollDirection.idle) {
                  model.handleScrollEnd();
                }
                return false;
              },
              child: CustomScrollView(
                controller: model.scrollController,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  // Top Spacer to initialy center the image
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: size.height * 0.15,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Hero(
                      tag: 'pfp_${post.postId}',
                      createRectTween: (begin, end) =>
                          ExpressiveRectTween(begin: begin, end: end),
                      child: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.7,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: MaterialShapes.fourLeafClover(
                                    color: Colors.transparent,
                                    size: size.width - 120,
                                    imageFit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      post.person.pfpPath,
                                    )),
                              ),
                              _buildMetadata(context, animation, model),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Placeholder for Profile Content (Phase 2)
                  SliverToBoxAdapter(
                    child: Opacity(
                      opacity: model.expansionProgress,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          SvgPicture.asset(
                            'assets/zigzag.svg',
                            width: size.width - 120,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatColumn(context, "1.2K", "Followers"),
                              _buildStatColumn(context, "456", "Following"),
                              // _buildStatButton(
                              //     context, Icons.star_outline, "Star"),
                            ],
                          ),
                          const SizedBox(height: 48),
                          Text(
                            "User's posts and other information will appear here.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 400),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Close Button
            Positioned(
              top: 24 + MediaQuery.of(context).padding.top,
              right: 24,
              child: _StaggeredBubble(
                animation: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.9, 1.0,
                      curve: Easing.emphasizedDecelerate),
                ),
                alignment: Alignment.center,
                child: Opacity(
                  opacity: model.expansionProgress,
                  child: Transform.scale(
                      scale: model.expansionProgress,
                      child: SizedBox(
                        height: 48,
                        width: 56,
                        child: IconButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHigh)),
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.audiowide(
                textStyle: (Theme.of(context).textTheme.displayMedium),
                fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context, Animation<double> animation,
      ProfilePictureViewerModel model) {
    final nameAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.70, 0.85, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.20, 0.30, curve: Easing.standardAccelerate),
    );
    final followingAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.75, 0.90, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.15, 0.25, curve: Easing.standardAccelerate),
    );
    final profileAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.80, 0.95, curve: Easing.emphasizedDecelerate),
      reverseCurve:
          const Interval(0.05, 0.15, curve: Easing.standardAccelerate),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Name Bubble
        Positioned(
          top: 40,
          left: 40,
          child: Opacity(
            opacity: (1.0 - model.expansionProgress).clamp(0.0, 1.0),
            child: _StaggeredBubble(
              animation: nameAnim,
              alignment: Alignment.centerLeft,
              child: _Bubble(
                supportText: post.person.userName,
                text: post.person.name,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                textColor: Theme.of(context).colorScheme.onSurface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ),
        // Actions
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Center(
              child: Column(
            children: [
              Opacity(
                  opacity: model.expansionProgress,
                  child: Column(
                    children: [
                      Text(
                        post.person.name,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        post.person.userName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  )),
              SizedBox(
                height: 24,
              ),
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: _StaggeredBubble(
                      animation: followingAnim,
                      alignment: Alignment.centerRight,
                      child: _ActionBubble(
                        label: 'Following',
                        icon: Icons.done,
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        textColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  Expanded(
                      child: _StaggeredBubble(
                    animation: profileAnim,
                    alignment: Alignment.centerRight,
                    child: _ActionBubble(
                      onTap: model.expandToProfile,
                      label: 'Profile',
                      icon: Icons.north_east,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      textColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  )),
                ],
              ),
            ],
          )),
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
        return Opacity(
          opacity: animation.value,
          child: Transform.scale(
            scale: animation.value,
            alignment: alignment,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final String supportText;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const _Bubble({
    required this.text,
    required this.supportText,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supportText,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
          ],
        ));
  }
}

class _UserNameBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _UserNameBubble({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(8)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const _ActionBubble({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 64,
        width: double.infinity,
        child: FilledButton.icon(
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
          ),
          onPressed: onTap ?? () {},
          icon: Icon(icon, color: textColor, size: 18),
          label: Text(
            label,
            style: GoogleFonts.manjari(
              height: 4.3,
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ));
  }
}
