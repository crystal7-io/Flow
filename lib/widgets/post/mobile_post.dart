import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/core/utils/format_post_timestamp.dart';
import 'package:redesigned/data/repositories/post_repository.dart';
import 'package:redesigned/widgets/comment_sheet.dart';
import 'package:redesigned/widgets/profile_picture_viewer.dart';
import 'package:redesigned/widgets/share_sheet.dart';
import 'package:redesigned/widgets/utils/m3expressive/button_group.dart';

import 'carousel_post_widget.dart';
import 'image_post_widget.dart';
import 'video_post.dart';

class MobilePost extends StatefulWidget {
  const MobilePost({super.key, required this.post});
  final Post post;

  @override
  State<MobilePost> createState() => _MobilePostState();
}

class _MobilePostState extends State<MobilePost> {
  bool liked = false;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    if (widget.post.isLiked) {
      liked = widget.post.isLiked;
    }
  }

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
                  Navigator.of(context, rootNavigator: true).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      transitionDuration: Durations.long3,
                      reverseTransitionDuration: Durations.medium1,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return ProfilePictureViewer(post: widget.post, animation: animation);
                      },
                    ),
                  );
                },
                child: Hero(
                  tag: 'pfp_${widget.post.person.id}',
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
            : VideoPost(post: widget.post as VideoPostObject),
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
                            return CommentSheet(
                              controller: scrollController,
                              postId: widget.post.postId,
                            );
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
                      context.read<PostRepository>().toggleLikeOnPostWithID(
                        postId: widget.post.postId,
                        userId: 'test_user',
                      );
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
