import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide ShimmerEffect;
import 'package:google_fonts/google_fonts.dart';
import 'package:material_3p/material_loading_indicator.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/widgets/comment/comment_view_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Bottom sheet showing comments for a post, with a text field to add a new
/// one at the bottom.
///
/// This is a dumb view now - all the fetching/pagination state lives in
/// CommentsViewModel. Whoever opens this sheet is expected to wrap it in a
/// ChangeNotifierProvider&lt;CommentViewModel&gt; scoped to the postId (see
/// mobile_post.dart for how it's done), otherwise context.watch below will
/// throw.
///
/// [controller] is handed to us by the DraggableScrollableSheet that hosts
/// this widget - we attach a listener to it to detect when the user's
/// scrolled near the bottom and trigger loading the next page.
class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key, required this.controller, required this.postId});
  final ScrollController controller;
  final String postId;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController _commentController = TextEditingController();

  /// How close to the bottom (in pixels) before we fire off the next page
  /// request. Same value HomeViewModel uses for the main feed.
  static const double _loadMoreThreshold = 200;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    _commentController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;

    final maxScroll = widget.controller.position.maxScrollExtent;
    final currentOffset = widget.controller.offset;

    if (maxScroll - currentOffset <= _loadMoreThreshold) {
      context.read<CommentViewModel>().loadMoreComments();
    }
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Clear input field and unfocus
    _commentController.clear();
    FocusScope.of(context).unfocus();

    final currentUser = accounts.isNotEmpty
        ? accounts[0].person
        : Person(
            id: 'current_user',
            name: 'You',
            userName: 'current_user',
            profilePicturePath: linkToPfp,
          );

    context.read<CommentViewModel>().addComment(person: currentUser, text: text);

    // Scroll to top for new comment
    widget.controller.animateTo(0, duration: Durations.medium4, curve: Easing.emphasizedDecelerate);
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<CommentViewModel>();

    return Column(
      children: [
        Center(
          child: Text(
            "Comments",
            style: TextTheme.of(context).titleLarge!.copyWith(
              fontFamily: "Google Sans Flex",
              fontSize: 22,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontVariations: [.weight(500), .width(70), .new("ROND", 100)],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Expanded(child: _buildCommentsList(theme, viewModel)),

        // Bottom Comment Input Field
        SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
              left: 8,
              right: 8,
              top: 8,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(minHeight: 56),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceBright,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                    child: TextField(
                      maxLines: 5,
                      minLines: 1,
                      controller: _commentController,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintText: "Add a comment...",
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 4),
                SizedBox(
                  height: 56,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                    ),
                    onPressed: _addComment,
                    icon: Icon(
                      Symbols.send,
                      color: theme.colorScheme.onTertiaryContainer,
                      size: 20,
                      weight: 800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Handles the four states the list can be in: first load, error on first
  /// load, empty, and loaded (optionally with a "loading next page" row
  /// tacked on the end).
  Widget _buildCommentsList(ThemeData theme, CommentViewModel viewModel) {
    if (viewModel.isLoading) {
      // return const Center(
      //   child: SizedBox(height: 80, width: 80, child: IndeterminateLoadingIndicator()),
      // );
      return ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
          SizedBox(height: 16),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: ColorScheme.of(context).surfaceBright,
              highlightColor: ColorScheme.of(context).surfaceContainerHighest,
              duration: Duration(milliseconds: 1500),
            ),
            enabled: true,
            child: CommentSkeleton(),
          ),
        ],
      );
    }

    if (viewModel.hasError && viewModel.comments.isEmpty) {
      return Center(
        child: Text(
          "Error loading comments",
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    if (viewModel.comments.isEmpty) {
      return Center(
        child: Text(
          "No comments yet",
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    final comments = viewModel.comments;
    final showLoader = viewModel.isLoadingNextPage;

    return ListView.builder(
      controller: widget.controller,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      itemCount: comments.length + (showLoader ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == comments.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(height: 80, width: 80, child: IndeterminateLoadingIndicator()),
            ),
          );
        }

        final comment = comments[index];
        return _buildCommentItem(comment)
            .animate()
            .fadeIn(delay: (index * 80).ms, duration: 250.ms, curve: Easing.standardDecelerate)
            .move(begin: const Offset(0, 64), duration: 400.ms, curve: Easing.standard);
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: DynamicAvatarClipper(comment.person.profilePictureShape),
                child: CachedNetworkImage(
                  height: 42,
                  width: 42,
                  fit: BoxFit.cover,
                  imageUrl: comment.person.pfpPath,
                  placeholder: (context, url) => Icon(
                    Icons.account_circle,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 40,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.person.userName,
                      style: GoogleFonts.googleSansCode(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceBright,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        comment.text,
                        style: TextTheme.of(context).bodyLarge!.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontFamily: "Google Sans Flex",
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "${_formatDateTime(comment.parsedDateTime)}  •  ${comment.likes} Likes",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommentSkeleton extends StatelessWidget {
  const CommentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = ColorScheme.of(context).surfaceContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Placeholder
          Skeleton.leaf(
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: surfaceColor, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 12),

          // Content Placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username Line
                Container(width: 100, height: 14, color: surfaceColor),
                const SizedBox(height: 4),

                // Comment Bubble Placeholder
                Skeleton.leaf(
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        bottomLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Date & Likes Meta Line
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(width: 110, height: 12, color: surfaceColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
