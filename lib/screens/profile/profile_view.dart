import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/widgets/profile_picture_viewer_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, required this.person, required this.animation});
  final Person person;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Full time length curve for elements entering screen
    // final fullEnterScreenCurve = CurvedAnimation(
    //   parent: animation,
    //   curve: Easing.standard,
    //   reverseCurve: Easing.standardAccelerate,
    // );

    // Background animation curve
    final backgroundCurve = CurvedAnimation(
      parent: animation,
      curve: Interval(0, 0.45, curve: Easing.standard),
      reverseCurve: Interval(0.65, 1.0, curve: Easing.standard),
    );

    // Background animation curve
    final actionCurve = CurvedAnimation(
      parent: animation,
      curve: Interval(0.5, 1.0, curve: Easing.standard),
      reverseCurve: Interval(0.65, 1.0, curve: Easing.standard),
    );

    return ChangeNotifierProvider(
      create: (context) {
        final model = ProfilePictureViewerModel(appService: context.read<AppService>());
        model.extractColors(person.pfpPath, theme.brightness);
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
                // Determine if the route is currently reversing (popping)
                // final isPopping = animation.status == AnimationStatus.reverse;

                return Opacity(
                  opacity: backgroundCurve.value,
                  child: Scaffold(
                    backgroundColor: colorScheme.surfaceContainer,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            SizedBox(
                              height: 56,
                              child: Row(
                                children: [
                                  ScaleTransition(
                                    scale: actionCurve,
                                    child: SizedBox(
                                      height: 56,
                                      width: 48,
                                      child: IconButton(
                                        style: ButtonStyle(
                                          backgroundColor: .all(colorScheme.inverseSurface),
                                          foregroundColor: .all(colorScheme.onInverseSurface),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Symbols.arrow_back, weight: 800),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Hero(
                                tag: 'pfp_${person.id}',
                                // createRectTween: (begin, end) =>
                                //     ExpressiveRectTween(begin: begin, end: end),
                                child: ClipPath(
                                  clipper: DynamicAvatarClipper(person.profilePictureShape),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    placeholderFadeInDuration: const Duration(seconds: 0),
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                          ),
                                        ),
                                    fit: BoxFit.cover,
                                    imageUrl: person.pfpPath,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
