import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/widgets/post_viewer.dart';

class CarouselPostWidget extends StatefulWidget {
  const CarouselPostWidget({super.key, required this.imagePost});
  final CarouselPostObject imagePost;

  @override
  State<CarouselPostWidget> createState() => _CarouselPostWidgetState();
}

class _CarouselPostWidgetState extends State<CarouselPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.imagePost.postId.toString(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (MediaQuery.widthOf(context)),
          maxHeight:
              (1 / widget.imagePost.aspectRatio) * (MediaQuery.widthOf(context)) -
              (MediaQuery.widthOf(context) / 8 - 8),
        ),
        child: CarouselView.weighted(
          consumeMaxWeight: false,
          flexWeights: [7, 1],
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
          onTap: (int i) {
            if (i == widget.imagePost.imagePaths.length) {
              return;
            }
            Navigator.of(context, rootNavigator: true).push(
              PageRouteBuilder(
                transitionDuration: Durations.medium1,
                pageBuilder: (context, animation, secondAnimtion) => FadeTransition(
                  opacity: animation,
                  child: CarouselPostViewer(
                    initPage: i,
                    imageTag: widget.imagePost.postId.toString(),
                    post: widget.imagePost,
                  ),
                ),
              ),
            );
          },
          itemSnapping: true,
          shrinkExtent: 0,
          children: [
            ...widget.imagePost.imagePaths.map(
              (e) => Builder(
                builder: (BuildContext context) => CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                  fit: BoxFit.cover,
                  imageUrl: e,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 56,
                child: IconButton.outlined(onPressed: () {}, icon: Icon(Symbols.chevron_backward)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
