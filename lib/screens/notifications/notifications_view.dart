import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/services/app_service.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/screens/notifications/notifications_view_model.dart';
import 'package:redesigned/widgets/utils/wave_divider.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationsViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: ListView(
        children: [
          SizedBox(height: 4),
          Padding(
            padding: .symmetric(vertical: 8, horizontal: 16),
            child: Text(
              "Notifications",
              style: GoogleFonts.limelight(
                textStyle: TextTheme.of(context).displaySmall!.copyWith(
                  // fontFamily: "Google Sans Flex",
                  color: ColorScheme.of(context).onSurfaceVariant,
                  fontWeight: .w800,
                  // fontVariations: [.weight(1000), .width(50)],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(width: 12),
                ...viewModel.notifFilters.map(
                  (filter) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      shape: StadiumBorder(),
                      selectedColor: ColorScheme.of(context).tertiaryContainer,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      labelStyle: TextStyle(
                        color: viewModel.selectedFilters.contains(filter)
                            ? ColorScheme.of(context).onTertiaryContainer
                            : null,
                        fontFamily: "Google Sans Flex",
                        fontVariations: [.weight(500), .width(70)],
                      ),
                      checkmarkColor: ColorScheme.of(context).onTertiaryContainer,
                      selected: viewModel.selectedFilters.contains(filter),
                      onSelected: (value) {
                        viewModel.toggleFilter(filter, value);
                      },
                      label: Text(filter),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: .symmetric(horizontal: 16),
            child: ClipRect(child: WavyDivider()),
          ),
          // _buildHeader(context, "New"),
          // ...viewModel.allNotifications[0].map((e) => NotifWidget(notification: e)),
          _buildHeader(context, "Today"),
          ...viewModel.allNotifications[1].map((e) => NotifWidget(notification: e)),
          _buildHeader(context, "Yesterday"),
          ...viewModel.allNotifications[2].map((e) => NotifWidget(notification: e)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class NotifWidget extends StatefulWidget {
  const NotifWidget({super.key, required this.notification});
  final Notif notification;
  @override
  State<NotifWidget> createState() => _NotifWidgetState();
}

class _NotifWidgetState extends State<NotifWidget> {
  late final NotifType type;

  @override
  void initState() {
    type = widget.notification.notifType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Row(
          children: [
            ClipPath(
              clipper: DynamicAvatarClipper(widget.notification.notifier.profilePictureShape),
              child: CachedNetworkImage(
                height: 50,
                width: 50,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholderFadeInDuration: const Duration(seconds: 0),
                placeholder: (context, url) => Icon(
                  Icons.account_circle_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                fit: BoxFit.contain,
                imageUrl: widget.notification.notifier.pfpPath,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification.notifier.userName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextTheme.of(context).titleSmall!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.2,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                widget.notification.time,
                                style: TextTheme.of(context).bodySmall!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.notification.textContent,
                            style: TextTheme.of(context).bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontFamily: "Google Sans Flex",
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0,
                            ),
                          ),
                          if (type == NotifType.commentLike)
                            Text(
                              (widget.notification as CommentLikeNotficaiton).commentText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextTheme.of(context).bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          else if (type == NotifType.commentReply)
                            Text(
                              (widget.notification as CommentReplyNotficaiton).commentText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextTheme.of(context).bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (type == NotifType.follow)
                      context.watch<AppService>().isFollowing(widget.notification.notifier)
                          ? TextButton(
                              onPressed: () {
                                context.read<AppService>().removeFollower(
                                  widget.notification.notifier,
                                );
                              },
                              child: const Text("Following"),
                            )
                          : FilledButton(
                              onPressed: () {
                                context.read<AppService>().addFollower(
                                  widget.notification.notifier,
                                );
                              },
                              child: const Text("Follow"),
                            )
                    else if (type == NotifType.commentReply)
                      IconButton(onPressed: () {}, icon: const Icon(Icons.expand_more))
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          height: 50,
                          width: 50,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          placeholderFadeInDuration: const Duration(seconds: 0),
                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://drive.google.com/uc?export=view&id=${widget.notification.contextImagePath}",
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
