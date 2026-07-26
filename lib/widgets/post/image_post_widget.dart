import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/widgets/post_viewer.dart';

class ImagePostWidget extends StatefulWidget {
  const ImagePostWidget({super.key, required this.imagePost});
  final ImagePostObject imagePost;

  @override
  State<ImagePostWidget> createState() => _ImagePostWidgetState();
}

class _ImagePostWidgetState extends State<ImagePostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                transitionDuration: Durations.medium1,
                pageBuilder: (context, animation, secondAnimtion) => FadeTransition(
                  opacity: animation,
                  child: ImagePostViewer(
                    imageTag: widget.imagePost.postId.toString(),
                    image: widget.imagePost.imagePath,
                  ),
                ),
              ),
            );
          },
          child: Hero(
            tag: widget.imagePost.postId.toString(),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholderFadeInDuration: const Duration(seconds: 0),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
              fit: BoxFit.contain,
              imageUrl: widget.imagePost.imagePath,
            ),
          ),
        ),
      ),
    );
  }
}
