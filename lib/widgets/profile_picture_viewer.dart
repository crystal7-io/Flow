import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/services/app_service.dart';
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
        final model = ProfilePictureViewerModel(appService: context.read<AppService>());
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
                    SizedBox(height: MediaQuery.paddingOf(context).top + 56),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Hero(
                        tag: 'pfp_${post.postId}',
                        createRectTween: (begin, end) =>
                            ExpressiveRectTween(begin: begin, end: end),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(MediaQuery.widthOf(context)),
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
                    const SizedBox(height: 40),
                    _buildUploads(context, animation, colorScheme),
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

    return Column(
      children: [
        // Name and Username
        _StaggeredBubble(
          animation: nameAnim,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.widthOf(context) - 48,
            child: FittedBox(
              child: Text(
                post.person.name,
                style: TextStyle(
                  fontFamily: 'Google Sans Flex',
                  color: colorScheme.onSurface,
                  height: 1,
                  fontVariations: [
                    //FontVariation.weight(1000.0), FontVariation.width(10)
                    FontVariation.weight(600.0),
                    FontVariation.opticalSize(200),
                    FontVariation.width(5),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
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
        SizedBox(height: 16),
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
                    : colorScheme.onPrimary,
                backgroundColor: model.isStarred
                    ? colorScheme.surfaceContainerLowest
                    : colorScheme.primary,
              ),
              ButtonGroupItem(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                width: 56,
                height: 64,
                onPressed: () {},
                icon: Symbols.message,
              ),
            ],
          ),
        ),

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

  Widget _buildUploads(BuildContext context, Animation<double> animation, ColorScheme colorScheme) {
    final uploadsAnim = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.92, 1.0, curve: Easing.emphasizedDecelerate),
    );

    return _StaggeredBubble(
      animation: uploadsAnim,
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: _DynamicUploadsGrid(colorScheme: colorScheme),
      ),
    );
  }
}

/// Data model for a single upload tile in the dynamic grid.
class _UploadItem {
  final String imageUrl;
  final String shapeName;

  const _UploadItem({required this.imageUrl, required this.shapeName});
}

/// Defines how a single row in the dynamic grid is laid out.
/// Each row has a fixed height and contains tiles with relative width ratios.
class _GridRow {
  final double heightRatio; // relative height (multiplied by base unit)
  final List<double> widthRatios; // each tile's width as a fraction of the row

  const _GridRow({required this.heightRatio, required this.widthRatios});
}

/// A dynamic, staggered grid for profile uploads using MaterialShapes.
///
/// Lays out images in visually varied rows with different height/width
/// combinations, inspired by Pinterest and the reference layout. Each image
/// is clipped into a different MaterialShape for an organic, premium feel.
class _DynamicUploadsGrid extends StatelessWidget {
  final ColorScheme colorScheme;

  const _DynamicUploadsGrid({required this.colorScheme});

  // The 12 uploads with lightweight picsum images (small resolution for speed)
  static const List<_UploadItem> _uploads = [
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow1/400/600', shapeName: 'sixSidedCookie'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow2/400/400', shapeName: 'ghostish'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow3/400/400', shapeName: 'sixSidedCookie'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow4/600/400', shapeName: 'bun'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow5/400/400', shapeName: 'heart'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow6/400/600', shapeName: 'pentagon'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow7/400/400', shapeName: 'diamond'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow8/400/400', shapeName: 'square'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow9/600/400', shapeName: 'arch'),
    _UploadItem(
      imageUrl: 'https://picsum.photos/seed/flow10/400/400',
      shapeName: 'eightLeafClover',
    ),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow11/400/600', shapeName: 'clampShell'),
    _UploadItem(imageUrl: 'https://picsum.photos/seed/flow12/400/400', shapeName: 'slanted'),
  ];

  // The row layout pattern – varied row heights and tile splits.
  // This pattern creates the dynamic, asymmetric look from the reference.
  static const List<_GridRow> _rowPatterns = [
    // Row 1: One tall image left (2/5 width), two stacked small right (3/5 width shared)
    _GridRow(heightRatio: 1.0, widthRatios: [0.33, 0.34, 0.33]),
    // Row 2: Three equal tiles
    _GridRow(heightRatio: 1.6, widthRatios: [0.55, 0.45]),
    // Row 3: Two tiles, right wider
    _GridRow(heightRatio: 1.3, widthRatios: [0.4, 0.6]),
    // Row 4: Two tiles, left wider
    _GridRow(heightRatio: 1.0, widthRatios: [0.6, 0.4]),
    // Row 5: Three tiles
    _GridRow(heightRatio: 1.2, widthRatios: [0.35, 0.3, 0.35]),
  ];

  @override
  Widget build(BuildContext context) {
    const double gap = 6.0;
    const double minTileSize = 80.0;
    final double baseUnit = MediaQuery.widthOf(context) * 0.28;

    int itemIndex = 0;
    final List<Widget> rows = [];

    for (final pattern in _rowPatterns) {
      if (itemIndex >= _uploads.length) break;

      final double rowHeight = (baseUnit * pattern.heightRatio).clamp(minTileSize, double.infinity);
      final int tilesInRow = pattern.widthRatios.length;
      final List<Widget> tiles = [];

      for (int t = 0; t < tilesInRow && itemIndex < _uploads.length; t++) {
        final upload = _uploads[itemIndex];
        tiles.add(
          Expanded(
            flex: (pattern.widthRatios[t] * 100).round(),
            child: SizedBox(height: rowHeight, child: _buildShapedTile(upload, rowHeight)),
          ),
        );
        if (t < tilesInRow - 1) {
          tiles.add(SizedBox(width: gap));
        }
        itemIndex++;
      }

      rows.add(
        SizedBox(
          height: rowHeight,
          child: Row(children: tiles),
        ),
      );
      rows.add(SizedBox(height: gap));
    }

    // Remove trailing gap
    if (rows.isNotEmpty && rows.last is SizedBox) {
      rows.removeLast();
    }

    return Column(children: rows);
  }

  /// Builds a single tile with the image clipped into the specified shape.
  Widget _buildShapedTile(_UploadItem upload, double tileSize) {
    final BorderRadius borderRadius;
    if (upload.shapeName == 'circle' ||
        upload.shapeName == 'ghostish' ||
        upload.shapeName == 'eightLeafClover' ||
        upload.shapeName == 'diamond') {
      borderRadius = BorderRadius.circular(9999);
    } else {
      borderRadius = BorderRadius.circular(016.0);
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: colorScheme.surfaceContainerHigh,
        child: CachedNetworkImage(
          imageUrl: upload.imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          placeholderFadeInDuration: const Duration(seconds: 0),
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
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
