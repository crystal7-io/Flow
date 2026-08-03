import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_3p/material_loading_indicator.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';
import 'package:redesigned/data/repositories/comment_repository.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key, required this.controller, required this.postId});
  final ScrollController controller;
  final String postId;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  late Future<List<Comment>> _commentsFuture;
  List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentsFuture = context.read<CommentsRepository>().getCommentsForPost(postId: widget.postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() async {
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

    final newComment = await context.read<CommentsRepository>().addComment(
      postId: widget.postId,
      person: currentUser,
      text: text,
    );

    if (!mounted) return;

    setState(() {
      _comments.insert(0, newComment);
    });

    // Scroll to top for new comment
    widget.controller.animateTo(0, duration: Durations.medium4, curve: Easing.emphasizedDecelerate);
  }

  String _formatDateTime(dynamic dateTime) {
    if (dateTime is String) {
      return dateTime;
    } else if (dateTime is DateTime) {
      final difference = DateTime.now().difference(dateTime);
      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        Expanded(
          child: FutureBuilder<List<Comment>>(
            future: _commentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && _comments.isEmpty) {
                return const Center(
                  child: SizedBox(height: 80, width: 80, child: IndeterminateLoadingIndicator()),
                );
              }

              if (snapshot.hasError && _comments.isEmpty) {
                return Center(
                  child: Text(
                    "Error loading comments",
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                );
              }

              // Store fetched list into state if not already set
              if (snapshot.hasData && _comments.isEmpty) {
                _comments = List.from(snapshot.data!);
              }

              if (_comments.isEmpty) {
                return Center(
                  child: Text(
                    "No comments yet",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: widget.controller,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return _buildCommentItem(comment)
                      .animate()
                      .fadeIn(
                        delay: (index * 80).ms,
                        duration: 250.ms,
                        curve: Easing.standardDecelerate,
                      )
                      .move(begin: const Offset(0, 64), duration: 400.ms, curve: Easing.standard);
                },
              );
            },
          ),
        ),

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
                        "${_formatDateTime(comment.dateTime)}  •  ${comment.likes} Likes",
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
