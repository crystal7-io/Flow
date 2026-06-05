import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_post_view_model.dart';
import '../../widgets/utils/custom_alert_dialog.dart';

// Changed to StatefulWidget to safely persist the ViewModel instance locally
class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late final CreatePostViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CreatePostViewModel(); // Retains state safely
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreatePostViewModel>.value(
      value: _viewModel,
      child: const _CreatePostViewContent(),
    );
  }
}

class _CreatePostViewContent extends StatefulWidget {
  const _CreatePostViewContent();

  @override
  State<_CreatePostViewContent> createState() => _CreatePostViewContentState();
}

class _CreatePostViewContentState extends State<_CreatePostViewContent> {
  late final CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();
    _carouselController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_carouselController.hasClients) return;

    final model = context.read<CreatePostViewModel>();
    final double width = _carouselController.position.viewportDimension;

    if (width > 0) {
      final int index = (_carouselController.offset / width).round();
      if (index != model.currentCarouselIndex && index >= 0 && index < model.mediaPaths.length) {
        model.setCurrentIndex(index);
      }
    }
  }

  @override
  void dispose() {
    _carouselController.removeListener(_onScroll);
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read model once for non-changing callback references
    final model = context.read<CreatePostViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 80,
        toolbarHeight: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surfaceContainerHigh,
              ),
            ),
            onPressed: () {
              if (model.mediaPaths.isNotEmpty || model.comment.trim().isNotEmpty) {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Discard changes dialog',
                  barrierColor: Colors.black54,
                  transitionDuration: const Duration(milliseconds: 320),
                  pageBuilder: (context, animation, __) => CustomAlertDialog(
                    animation: animation,
                    title: const Text("Discard changes?"),
                    content: const Text("If you go back now, your draft will be lost."),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            context.pop(); // Close dialog
                            context.pop(); // Go back
                          },
                          child: const Text(
                            "Discard",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  transitionBuilder: (context, animation, _, child) {
                    final fadeAnim = CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
                    );

                    final slideAnim = Tween<Offset>(
                      begin: const Offset(0, -0.25),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Easing.emphasizedDecelerate,
                    ));

                    return FadeTransition(
                      opacity: fadeAnim,
                      child: SlideTransition(
                        position: slideAnim,
                        child: child,
                      ),
                    );
                  },
                );
              } else {
                context.pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          SizedBox(
            height: 56,
            width: 56,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.tertiary,
                ),
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.visibility_outlined),
              tooltip: 'Preview',
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 56,
            width: 64,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary,
                ),
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.done),
              tooltip: 'Done',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              minLines: 1,
              maxLines: 4,
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
              onChanged: model.setComment,
              style: GoogleFonts.abel(
                fontSize: 22,
                height: 1.4,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Add a comment. . .',
                hintStyle: GoogleFonts.abel(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.outline,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Micro-rebuild target: Only rebuilds the Media View + Buttons

          _buildAspectRatioButtons(context, context.watch<CreatePostViewModel>()),
          Expanded(
              child: Center(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
              child: _mediaView(context, context.watch<CreatePostViewModel>()),
            ),
          ))
        ],
      ),
      bottomNavigationBar: Consumer<CreatePostViewModel>(
        builder: (context, watchModel, _) =>
            _FloatingToolbar(model: watchModel, controller: _carouselController),
      ),
    );
  }

  Widget _mediaView(BuildContext context, CreatePostViewModel model) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;
        final ratio = model.selectedAspectRatio;

        double width = availableWidth;
        double height = width / ratio;

        if (height > availableHeight) {
          height = availableHeight;
          width = height * ratio;
        }

        if (model.mediaPaths.isEmpty) {
          return _buildEmptyMediaView(context, model, width, height);
        } else {
          return _buildCarouselMediaView(context, model, width, height);
        }
      },
    );
  }

  Widget _buildEmptyMediaView(
      BuildContext context, CreatePostViewModel model, double width, double height) {
    return AnimatedContainer(
      key: const ValueKey('empty_media_view'),
      duration: Durations.medium1,
      curve: Easing.standard,
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'Add Image and Videos',
            style: GoogleFonts.googleSansFlex(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselMediaView(
      BuildContext context, CreatePostViewModel model, double width, double height) {
    return AnimatedContainer(
      key: const ValueKey('carousel_media_view'),
      duration: Durations.medium1,
      curve: Easing.standard,
      width: width,
      height: height,
      child: CarouselView.weighted(
        flexWeights: const [9],
        consumeMaxWeight: true,
        itemSnapping: true,
        shrinkExtent: 0,
        controller: _carouselController,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        children: model.mediaPaths.asMap().entries.map((entry) {
          final index = entry.key;
          final path = entry.value;
          final isRemoving = model.removingIndex == index;

          return AnimatedScale(
            scale: isRemoving ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInBack,
            child: AnimatedOpacity(
              opacity: isRemoving ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AspectRatio(
                aspectRatio: model.selectedAspectRatio,
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAspectRatioButtons(BuildContext context, CreatePostViewModel model) {
    final ratios = [
      {'label': '1:1', 'value': 1.0},
      {'label': '4:5', 'value': 4 / 5},
      {'label': '5:4', 'value': 5 / 4},
      {'label': '16:9', 'value': 16 / 9},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ratios.map((ratio) {
        final isSelected = model.selectedAspectRatio == ratio['value'];
        return SizedBox(
          height: 46,
          child: FilledButton(
            onPressed: () => model.setSelectedAspectRatio(ratio['value'] as double),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isSelected ? Theme.of(context).colorScheme.inverseSurface : Colors.transparent,
              foregroundColor: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: Text(
              ratio['label'] as String,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FloatingToolbar extends StatelessWidget {
  const _FloatingToolbar({required this.model, required this.controller});
  final CreatePostViewModel model;
  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasMedia = model.mediaPaths.isNotEmpty;

    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          child: hasMedia
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit Button
                    SizedBox(
                      height: 64,
                      width: 64,
                      child: IconButton.filledTonal(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(cs.tertiaryContainer),
                          foregroundColor: WidgetStatePropertyAll(cs.onTertiaryContainer),
                        ),
                        onPressed: hasMedia ? () {} : null,
                        icon: Icon(Symbols.edit, weight: 700),
                        tooltip: 'Edit',
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),

                    // Delete Button
                    SizedBox(
                      height: 64,
                      width: 56,
                      child: IconButton.filledTonal(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(cs.secondaryContainer),
                          foregroundColor: WidgetStatePropertyAll(cs.onSecondaryContainer),
                        ),
                        onPressed: hasMedia
                            ? () => showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: 'Delete media dialog',
                                  barrierColor: Colors.black54,
                                  transitionDuration: const Duration(milliseconds: 320),
                                  pageBuilder: (context, animation, __) => CustomAlertDialog(
                                    animation: animation,
                                    title: const Text("Remove media ?"),
                                    content: const Text("All changes done to this will be lost"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          )),
                                      SizedBox(
                                        height: 56,
                                        child: FilledButton(
                                            onPressed: () async {
                                              final indexToDelete = model.currentCarouselIndex;

                                              // Close dialog
                                              context.pop();

                                              // Trigger item removal animation
                                              model.setRemovingIndex(indexToDelete);

                                              // Wait for item animation
                                              await Future.delayed(
                                                  const Duration(milliseconds: 300));

                                              // Scroll to previous or next item if possible
                                              if (indexToDelete > 0) {
                                                await controller.animateToItem(
                                                  indexToDelete - 1,
                                                  duration: const Duration(milliseconds: 400),
                                                  curve: Curves.easeInOutCubic,
                                                );
                                                await Future.delayed(
                                                    const Duration(milliseconds: 100));
                                              } else if (indexToDelete == 0 &&
                                                  model.mediaPaths.length > 1) {
                                                await controller.animateToItem(
                                                  indexToDelete + 1,
                                                  duration: const Duration(milliseconds: 400),
                                                  curve: Curves.easeInOutCubic,
                                                );

                                                // Wait a tiny bit for the animation to settle
                                                await Future.delayed(
                                                    const Duration(milliseconds: 50));
                                              }

                                              // Remove from model
                                              model.removeMediaAtIndex(indexToDelete);

                                              // If we were at index 0 and scrolled to 1,
                                              // after removal index 1 becomes index 0.
                                              // We must jump the controller to 0 to stay on the correct item.
                                              if (indexToDelete == 0 &&
                                                  model.mediaPaths.isNotEmpty) {
                                                controller.jumpTo(0);
                                              }

                                              model.setRemovingIndex(null);
                                            },
                                            child: Text(
                                              "Remove",
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            )),
                                      )
                                    ],
                                  ),
                                  transitionBuilder: (context, animation, _, child) {
                                    // Opacity: 0→1 only in the first 40% of the animation
                                    final fadeAnim = CurvedAnimation(
                                      parent: animation,
                                      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
                                    );

                                    // Slide: Y offset (top-to-bottom slide)
                                    final slideAnim = Tween<Offset>(
                                      begin: const Offset(0, -0.25),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Easing.emphasizedDecelerate,
                                    ));

                                    return FadeTransition(
                                      opacity: fadeAnim,
                                      child: SlideTransition(
                                        position: slideAnim,
                                        child: child,
                                      ),
                                    );
                                  },
                                )
                            : null,
                        icon: Icon(Symbols.delete, weight: 700),
                        disabledColor: cs.onPrimaryContainer.withValues(alpha: 0.35),
                        tooltip: 'Delete',
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),

                    // Add Button
                    SizedBox(
                      height: 72,
                      width: 86,
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(cs.inversePrimary),
                          foregroundColor: WidgetStatePropertyAll(cs.onPrimaryContainer),
                        ),
                        onPressed: model.pickMedia,
                        icon: Icon(
                          Symbols.add,
                          weight: 800,
                        ),
                      ),
                    )
                  ],
                )
              : SizedBox(
                  height: 72,
                  child: FilledButton.icon(
                    style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(cs.onSecondary),
                        backgroundColor: WidgetStatePropertyAll(cs.secondary)),
                    onPressed: model.pickMedia,
                    label: const Text(
                      "Add",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    icon: Icon(
                      Symbols.add_2,
                      size: 18,
                      weight: 700,
                    ),
                  ))),
    );
  }
}
