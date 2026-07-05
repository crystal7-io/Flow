import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/utils/dynamic_avatar_clipper.dart';
import 'package:redesigned/data/mock_data.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key, required this.controller});
  final ScrollController controller;

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  late List<Comment> _comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize comments from mock data.
    _comments = comments.isNotEmpty ? comments[0] : [];
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    // If Logged in User Data is not pressent
    // Use a default/mock person for the currently logged in user accounts[0].person
    final currentUser = accounts.isNotEmpty
        ? accounts[0].person
        : Person(
            id: 'current_user',
            name: 'You',
            userName: 'current_user',
            profilePicturePath: linkToPfp,
          );

    setState(() {
      _comments.insert(
        0,
        Comment(
          person: currentUser,
          text: _commentController.text.trim(),
          dateTime: 'Just now',
          likes: 0,
          isLiked: false,
          replies: [],
        ),
      );
    });
    widget.controller.animateTo(0, duration: Durations.medium4, curve: Easing.emphasizedDecelerate);
    _commentController.clear();
    FocusScope.of(context).unfocus();
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

        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            controller: widget.controller,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return _buildCommentItem(comment)
                  .animate()
                  .fadeIn(
                    delay: (index * 42).ms,
                    duration: 400.ms,
                    curve: Easing.standardDecelerate,
                  )
                  .move(begin: const Offset(0, 64), duration: 400.ms, curve: Easing.standard);
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
              crossAxisAlignment: .end,
              children: [
                // User Avatar

                // Input text field
                Expanded(
                  child: Container(
                    alignment: .center,
                    constraints: const BoxConstraints(minHeight: 56),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceBright,
                      borderRadius: .circular(12),
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
                        contentPadding: .symmetric(vertical: 0),
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

                SizedBox(width: 4),
                SizedBox(
                  height: 56,
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: .all(Theme.of(context).colorScheme.tertiaryContainer),
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
              // Avatar
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

              // Username, Comment Bubble, Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.person.userName,
                      style: GoogleFonts.googleSansCode(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: .w400,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Comment bubble wrapping to contents
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceBright,
                        borderRadius: BorderRadius.only(
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

                    // Small Like Icon button next to the bubble
                    // IconButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       if (comment.isLiked) {
                    //         comment.isLiked = false;
                    //         comment.likes = (comment.likes > 0) ? comment.likes - 1 : 0;
                    //       } else {
                    //         comment.isLiked = true;
                    //         comment.likes += 1;
                    //       }
                    //     });
                    //   },
                    //   icon: Icon(
                    //     comment.isLiked ? Icons.favorite : Icons.favorite_border,
                    //     color: comment.isLiked
                    //         ? Colors.red
                    //         : theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    //     size: 18,
                    //   ),
                    // ),
                    const SizedBox(height: 6),

                    // Metadata: Time and Likes count
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
