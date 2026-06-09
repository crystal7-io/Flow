import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:redesigned/core/models/models.dart';

class ImagePostViewer extends StatelessWidget {
  const ImagePostViewer({
    super.key,
    required this.image,
    required this.imageTag,
  });
  final String image;
  final String imageTag;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                color: const Color.fromARGB(255, 212, 212, 212),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(136, 59, 59, 59),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Center(
              child: Hero(
                tag: imageTag,
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholderFadeInDuration: const Duration(seconds: 0),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                  fit: BoxFit.contain,
                  imageUrl: "https://drive.google.com/uc?export=view&id=$image",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselPostViewer extends StatelessWidget {
  const CarouselPostViewer({
    super.key,
    required this.post,
    required this.imageTag,
    required this.initPage,
  });
  final CarouselPostObject post;
  final String imageTag;
  final int initPage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: IconButton(
                color: const Color.fromARGB(255, 212, 212, 212),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(136, 59, 59, 59),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            Center(
              child: Hero(
                tag: imageTag,
                child: FlutterCarousel(
                  items: post.imagePaths
                      .map(
                        (e) => Builder(
                          builder: (BuildContext context) => ClipRRect(
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              placeholderFadeInDuration: const Duration(
                                seconds: 0,
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                    ),
                                  ),
                              fit: BoxFit.contain,
                              imageUrl:
                                  "https://drive.google.com/uc?export=view&id=$e",
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  options: FlutterCarouselOptions(
                    initialPage: initPage,
                    viewportFraction: 1,
                    slideIndicator: CircularWaveSlideIndicator(
                      slideIndicatorOptions: const SlideIndicatorOptions(
                        indicatorRadius: 4.8,
                        indicatorBackgroundColor: Color.fromARGB(
                          98,
                          190,
                          190,
                          190,
                        ),
                        currentIndicatorColor: Colors.white,
                      ),
                    ),
                    floatingIndicator: false,
                    showIndicator: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
