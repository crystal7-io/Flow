import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:libmonet/libmonet.dart';
import 'package:redesigned/core/utils/color.dart';

class ProfilePictureViewerModel extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  // double _expansionProgress = 0.0;

  bool _isFollowing = false;
  bool _isStarred = false;

  bool get isFollowing => _isFollowing;
  bool get isStarred => _isStarred;

  ColorScheme? _colorScheme;
  ColorScheme? get colorScheme => _colorScheme;

  ProfilePictureViewerModel() {
    // scrollController.addListener(_onScroll);
  }

  void extractColors(String imagePath, Brightness brightness) async {
    try {
      final seedColor = await DynamicSchemeExtension.extractColorFromImageProvider(
        CachedNetworkImageProvider(imagePath),
      );
      _colorScheme = DynamicScheme.withDefaults(
        sourceColor: TonalPaletteSourceColor.fromArgb(seedColor.toARGB32()),
        variant: .vibrant,
        isDark: brightness == .dark,
        platform: .phone,
        specVersion: .spec2026,
      ).toColorScheme(lazy: true);
      notifyListeners();
    } catch (e) {
      debugPrint("Error extracting color scheme: $e");
    }
  }

  void toggleFollowing() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }

  void toggleStar() {
    _isStarred = !_isStarred;
    notifyListeners();
  }

  // double get expansionProgress => _expansionProgress;
  // final double threshold = 200.0;

  // void _onScroll() {
  //   // Determine expansion progress based on scroll offset
  //   // Let's say 200 pixels of scroll completes the transition to opaque
  //   final newProgress = (scrollController.offset / threshold).clamp(0.0, 1.0);

  //   if (newProgress != _expansionProgress) {
  //     _expansionProgress = newProgress;
  //     notifyListeners();
  //   }
  // }

  // void handleScrollEnd() {
  //   if (_expansionProgress > 0 && _expansionProgress < 1) {
  //     final target = _expansionProgress > 0.5 ? threshold : 0.0;
  //     scrollController.animateTo(
  //       target,
  //       duration: Durations.medium3,
  //       curve: Easing.emphasizedDecelerate,
  //     );
  //   }
  // }

  // void expandToProfile() {
  //   scrollController.animateTo(
  //     200.0,
  //     duration: Durations.long2,
  //     curve: Easing.emphasizedDecelerate,
  //   );
  // }

  // @override
  // void dispose() {
  //   scrollController.removeListener(_onScroll);
  //   scrollController.dispose();
  //   super.dispose();
  // }
}
