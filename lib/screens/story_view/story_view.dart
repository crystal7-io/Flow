import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/screens/story_view/story_view_model.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key});

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  late AnimationController _controller;

  void createController() {
    final viewModel = context.read<StoryViewModel>();
    _controller =
        AnimationController(
            vsync: this,
            duration: viewModel.currentStory.duration,
          )
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) async {
            if (status == AnimationStatus.completed) {
              viewModel.nextStory(() {
                if (mounted) context.pop();
              });
              if (viewModel.currentIndex != 0 ||
                  status == AnimationStatus.completed) {
                // If moved to next story, reset and restart controller
                _controller.duration = viewModel.currentStory.duration;
                _controller.reset();
                _controller.forward();
              }
            }
          });
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createController();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StoryViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTapDown: (details) {
                _controller.stop();
              },
              onTapUp: (details) {
                _controller.forward();
              },
              child: Listener(
                onPointerUp: (event) {
                  if (event.position.dx >
                      MediaQuery.of(context).size.width / 2) {
                    viewModel.nextStory(() {
                      context.pop();
                    });
                  } else {
                    viewModel.previousStory();
                  }
                  _controller.reset();
                  _controller.duration = viewModel.currentStory.duration;
                  _controller.forward();
                },
                child: Center(
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    placeholderFadeInDuration: const Duration(seconds: 0),
                    placeholder: (context, url) => Icon(
                      Icons.account_circle_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    fit: BoxFit.contain,
                    imageUrl: viewModel.currentStory.pathToMedia,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        height: 45,
                        width: 45,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        placeholderFadeInDuration: const Duration(seconds: 0),
                        placeholder: (context, url) => Icon(
                          Icons.account_circle_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        fit: BoxFit.contain,
                        imageUrl: viewModel.person.pfpPath,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          viewModel.person.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          "${viewModel.currentStory.uploadTime} ago",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: viewModel.storyGroup.stories
                      .mapIndexed(
                        (index, element) => Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: viewModel.currentIndex > index
                                      ? 1
                                      : viewModel.currentIndex < index
                                      ? 0
                                      : _controller.value,
                                ),
                              ),
                              SizedBox(
                                width: index == viewModel.length - 1 ? 0 : 4,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            Column(
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 90,
                      child: SearchBar(
                        textStyle: const WidgetStatePropertyAll(
                          TextStyle(height: 1.2),
                        ),
                        shadowColor: const WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 12),
                        ),
                        leading: Icon(Icons.reply_outlined),
                        hintText: "Reply to this story",
                      ),
                    ),
                    SizedBox(
                      height: 56,
                      width: 56,
                      child: IconButton.filledTonal(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_outline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
