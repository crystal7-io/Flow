import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:redesigned/core/models/post.dart';

import 'carousel_post_widget.dart';
import 'image_post_widget.dart';
import 'video_post.dart';

class DesktopPost extends StatefulWidget {
  const DesktopPost({super.key, required this.post});
  final Post post;

  @override
  State<DesktopPost> createState() => _DesktopPostState();
}

class _DesktopPostState extends State<DesktopPost> {
  bool liked = false;
  int currentPage = 0;
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).width / (2.5 * widget.post.aspectRatio),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2.5,
            child: widget.post.type == PostType.image
                ? ImagePostWidget(imagePost: widget.post as ImagePostObject)
                : widget.post.type == PostType.carosel
                ? CarouselPostWidget(imagePost: widget.post as CarouselPostObject)
                : VideoPost(post: widget.post as VideoPostObject),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          placeholderFadeInDuration: const Duration(seconds: 0),
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          fit: BoxFit.contain,
                          imageUrl: widget.post.person.pfpPath,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.person.name,
                            style: GoogleFonts.googleSansFlex(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.post.person.userName,
                            style: GoogleFonts.googleSansFlex(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              child: IconButton(onPressed: () {}, icon: Icon(Symbols.favorite)),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 40,
                              child: FilledButton.tonalIcon(
                                onPressed: () {},
                                icon: Icon(Icons.reply_outlined),
                                label: const Text("16K"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 40,
                              child: IconButton.filledTonal(
                                onPressed: () {},
                                icon: const Icon(Symbols.send, weight: 700, size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 40,
                              child: IconButton.filledTonal(
                                onPressed: () {},
                                icon: const Icon(Icons.bookmark_outline, weight: 700, size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.\nIncididunt ut labore et dolore magna aliqua.",
                        ),
                        const SizedBox(height: 16),
                        widget.post.tags.isNotEmpty
                            ? Text(
                                "Tags",
                                style: GoogleFonts.googleSansFlex(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.post.tags
                              .map(
                                (e) => ActionChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: Colors.transparent),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                                  onPressed: () {},
                                  label: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
