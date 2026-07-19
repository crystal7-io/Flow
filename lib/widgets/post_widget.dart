import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/core/utils/format_post_timestamp.dart';
import 'package:redesigned/widgets/post_viewer.dart';
import 'package:redesigned/widgets/profile_picture_viewer.dart';
import 'package:redesigned/widgets/share_sheet.dart';
import 'package:redesigned/widgets/utils/m3expressive/button_group.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:redesigned/widgets/comment_sheet.dart';

// Time Dilation:
// import 'package:flutter/scheduler.dart' as sche;

class MobilePost extends StatefulWidget {
  const MobilePost({super.key, required this.post});
  final Post post;
  // final Function openComment;
  @override
  State<MobilePost> createState() => _MobilePostState();
}

class _MobilePostState extends State<MobilePost> {
  bool liked = false;
  bool saved = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 16, top: 12, bottom: 0),
          child: Row(
            mainAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // sche.timeDilation = 8;
                  Navigator.of(context, rootNavigator: true).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      transitionDuration: Durations.long3,
                      reverseTransitionDuration: Durations.medium1,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ProfilePictureViewer(post: widget.post, animation: animation);
                        // ProfileView(person: widget.post.person, animation: animation);
                      },
                    ),
                  );
                },
                child: Hero(
                  tag: 'pfp_${widget.post.person.id}',
                  // createRectTween: (begin, end) => ExpressiveRectTween(begin: begin, end: end),
                  child: ClipPath(
                    clipper: DynamicAvatarClipper(widget.post.person.profilePictureShape),
                    child: CachedNetworkImage(
                      height: 46,
                      width: 46,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      placeholderFadeInDuration: const Duration(seconds: 0),
                      placeholder: (context, url) => Icon(
                        Icons.account_circle_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      fit: BoxFit.cover,
                      imageUrl: widget.post.person.pfpPath,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  Text(
                    widget.post.person.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: "Google Sans Flex",
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '@${widget.post.person.userName}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: "Google Sans Flex",
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        widget.post.type == PostType.image
            ? ImagePostWidget(imagePost: widget.post as ImagePostObject)
            : widget.post.type == PostType.carosel
            ? CarouselPostWidget(imagePost: widget.post as CarouselPostObject)
            : ReelPost(post: widget.post as ReelPostObject),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
          child: Align(
            alignment: .centerLeft,
            child: Text(
              widget.post.subTitle,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontFamily: "Google Sans Flex",
                color: Theme.of(context).colorScheme.onSurface,
                fontVariations: [.weight(400), .new("ROND", 100)],
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        Padding(
          padding: EdgeInsetsGeometry.only(left: 18, right: 8),
          child: Row(
            children: [
              Text(
                formatPostTimestamp(widget.post.dateTime),
                style: TextStyle(
                  fontFamily: "Google Sans Flex",
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.outline,
                  fontVariations: [.weight(700), .width(50), .new("ROND", 100)],
                ),
              ),
              Spacer(),
              StandardButtonGroup(
                alignment: MainAxisAlignment.end,
                spacing: 4,
                items: [
                  ButtonGroupItem(
                    width: 44,
                    height: 56,
                    onPressed: () {
                      showModalBottomSheet(
                        useRootNavigator: true,
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          expand: false,
                          snap: true,
                          builder: (context, scrollController) {
                            return ShareSheet(controller: scrollController);
                          },
                        ),
                      );
                    },
                    icon: Symbols.forward,
                  ),
                  ButtonGroupItem(
                    width: 56,
                    height: 56,
                    onPressed: () {
                      showModalBottomSheet(
                        useRootNavigator: true,
                        context: context,
                        sheetAnimationStyle: AnimationStyle(
                          curve: Easing.emphasizedDecelerate,
                          reverseCurve: Easing.emphasizedAccelerate,
                        ),
                        showDragHandle: true,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          expand: false,
                          snap: true,
                          builder: (context, scrollController) {
                            return CommentSheet(controller: scrollController);
                          },
                        ),
                      );
                    },
                    icon: Symbols.comment,
                  ),
                  ButtonGroupItem(
                    backgroundColor: liked ? Theme.of(context).colorScheme.primaryFixed : null,
                    foregroundColor: liked ? Theme.of(context).colorScheme.onPrimaryFixed : null,
                    height: 56,
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                      });
                    },
                    width: widget.post.likes != 0 ? null : 64,
                    icon: liked ? Icons.favorite : Symbols.favorite_border,
                    label: widget.post.likes != 0
                        ? Text(
                            NumberFormat.compact().format(widget.post.likes),
                            style: TextStyle(
                              height: 1,
                              fontSize: 18,
                              fontFamily: "Google Sans Flex",
                              fontVariations: [
                                .weight(600),
                                FontVariation("ROND", 100),
                                .width(30),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 8),
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
    this.color,
  });
  final Color? color;
  final String title;
  final void Function() onTap;
  final Widget leading;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      iconColor: color,
      onTap: onTap,
      titleTextStyle: GoogleFonts.googleSansFlex(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

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
                : ReelPost(post: widget.post as ReelPostObject),
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
                              child: SelectButton(
                                isSelected: liked,
                                onPressed: () {
                                  setState(() {
                                    liked = !liked;
                                  });
                                },
                                selectedColor: Colors.red,
                                selectedIcon: Icons.favorite,
                                unselectedIcon: Icons.favorite_outline,
                                title: "23K",
                              ),
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
          // itemExtent: (MediaQuery.widthOf(context)),
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
      // const Align(
      // alignment: Alignment.bottomRight, child: Text("2/3")),
    );
  }
}

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

class ReelPost extends StatefulWidget {
  const ReelPost({super.key, required this.post});
  final ReelPostObject post;
  @override
  State<ReelPost> createState() => _ReelPostState();
}

class _ReelPostState extends State<ReelPost> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller =
        VideoPlayerController.networkUrl(
            Uri.parse("https://drive.google.com/uc?export=view&id=${widget.post.sourcePath}"),
          )
          ..initialize().then((_) {
            //  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
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

class SelectButton extends StatefulWidget {
  const SelectButton({
    super.key,
    required this.title,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.isSelected,
    required this.onPressed,
    this.selectedColor,
    this.unselectedColor,
  });
  final String title;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final bool isSelected;
  final Function onPressed;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  State<SelectButton> createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> with TickerProviderStateMixin {
  double scaleValue = 1;

  void onTap() {
    widget.onPressed();
    setState(() {
      scaleValue = 1.4;
    });
    Future.delayed(Durations.short3, () {
      setState(() {
        scaleValue = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: IconButton.filledTonal(
        onPressed: onTap,
        // label: Text(widget.title),
        icon: AnimatedScale(
          duration: Durations.short3,
          scale: scaleValue,
          child: Icon(
            widget.isSelected ? widget.selectedIcon : widget.unselectedIcon,
            color: widget.isSelected ? widget.selectedColor : widget.unselectedColor,
          ),
        ),
      ),
    );
  }
}
