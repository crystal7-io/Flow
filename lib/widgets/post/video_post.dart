import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:redesigned/core/models/post.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({super.key, required this.post});
  final VideoPostObject post;

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller =
        VideoPlayerController.networkUrl(
            Uri.parse("https://drive.google.com/uc?export=view&id=${widget.post.sourcePath}"),
          )
          ..initialize().then((_) {
            setState(() {
              controller.play();
              controller.setVolume(0);
            });
          });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: AspectRatio(
          aspectRatio: widget.post.aspectRatio,
          child: Stack(
            children: [
              VisibilityDetector(
                key: ObjectKey(widget.key),
                child: VideoPlayer(controller),
                onVisibilityChanged: (vibility) {
                  setState(() {
                    vibility.visibleFraction > 0.5 ? controller.play() : controller.pause();
                  });
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton.filledTonal(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {},
                      icon: const Icon(size: 16, Icons.volume_up_outlined),
                    ),
                  ),
                  VideoProgressIndicator(
                    controller,
                    colors: VideoProgressColors(playedColor: Theme.of(context).colorScheme.primary),
                    allowScrubbing: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
