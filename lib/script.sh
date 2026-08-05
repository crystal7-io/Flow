#!/usr/bin/env bash
# apply_comment_pagination.sh
#
# Wires up paginated ("load more on scroll") comments for the comment sheet.
# Run this from inside your `lib` folder:
#
#   cd lib
#   bash apply_comment_pagination.sh
#
# What it touches:
#   - screens/comments/comments_view_model.dart   (new file)
#   - widgets/comment_sheet.dart                   (overwritten)
#   - widgets/post/mobile_post.dart                (patched in place)
#
# It's idempotent-ish for the new file (will just overwrite it again if you
# rerun), but the mobile_post.dart patch will fail loudly instead of double
# patching if it can't find the exact block it's looking for.

set -euo pipefail

if [ ! -f "core/models/models.dart" ] && [ ! -d "screens" ]; then
  echo "Doesn't look like you're inside the lib/ folder. cd into lib and rerun."
  exit 1
fi

echo "-> creating screens/comments/comments_view_model.dart"
mkdir -p screens/comments

cat > screens/comments/comments_view_model.dart <<'EOF'
import 'package:flutter/foundation.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/repositories/comment_repository.dart';

/// ViewModel for a single post's comment sheet.
///
/// I'm following the same pattern I used for HomeViewModel: a ChangeNotifier
/// that owns a repository, exposes state as getters, and calls
/// notifyListeners() after anything that changes what's on screen. The view
/// (CommentSheet) is not supposed to talk to CommentsRepository directly -
/// it should only ever go through this.
///
/// This one is scoped to a single postId, so unlike HomeViewModel it's not
/// registered globally in AppProvider - it gets created fresh (with
/// ChangeNotifierProvider) every time a comment sheet is opened, and thrown
/// away when the sheet closes.
class CommentsViewModel extends ChangeNotifier {
  final CommentsRepository _commentsRepository;
  final String postId;

  CommentsViewModel(this._commentsRepository, this.postId) {
    getInitialComments();
  }

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  /// True only for the very first load (used to show the big centered
  /// spinner). Not used again after that, even while loading more pages.
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  /// True while a "load more" request is in flight. Drives the small
  /// spinner at the bottom of the list.
  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;

  /// Flips to false once the repo gives us back an empty page, so we stop
  /// bothering it with more requests.
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  bool _hasError = false;
  bool get hasError => _hasError;

  /// Fetches the first page of comments for [postId]. Called once from the
  /// constructor, doesn't need to be called manually.
  Future<void> getInitialComments() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _comments = await _commentsRepository.getCommentsForPost(postId: postId);
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches the next page, using the last loaded comment's timestamp as the
  /// cursor. Meant to be called from a scroll listener once the user gets
  /// close to the bottom of the list - see CommentSheet's _onScroll.
  ///
  /// Safe to call this repeatedly (e.g. from every scroll tick) - it no-ops
  /// if a request is already in flight or there's nothing left to fetch.
  Future<void> loadMoreComments() async {
    if (_isLoadingNextPage || !_hasMoreData || _comments.isEmpty) return;

    _isLoadingNextPage = true;
    notifyListeners();

    try {
      final nextPage = await _commentsRepository.getCommentsForPost(
        postId: postId,
        lastDateTime: _comments.last.parsedDateTime,
      );

      if (nextPage.isEmpty) {
        _hasMoreData = false;
      } else {
        _comments.addAll(nextPage);
      }
    } catch (e) {
      // Leave _hasMoreData as-is so the next scroll tick just tries again
      // instead of permanently giving up on one failed request.
    } finally {
      _isLoadingNextPage = false;
      notifyListeners();
    }
  }

  /// Adds a comment and drops it at the top of the list right away, instead
  /// of waiting on a refetch. Doesn't touch the pagination cursor since it
  /// only ever inserts at index 0.
  Future<void> addComment({required Person person, required String text}) async {
    final newComment = await _commentsRepository.addComment(
      postId: postId,
      person: person,
      text: text,
    );
    _comments.insert(0, newComment);
    notifyListeners();
  }
}
EOF

echo "-> overwriting widgets/comment_sheet.dart"

cat > widgets/comment_sheet.dart <<'EOF'
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
import 'package:redesigned/screens/comments/comments_view_model.dart';

/// Bottom sheet showing comments for a post, with a text field to add a new
/// one at the bottom.
///
/// This is a dumb view now - all the fetching/pagination state lives in
/// CommentsViewModel. Whoever opens this sheet is expected to wrap it in a
/// ChangeNotifierProvider<CommentsViewModel> scoped to the postId (see
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
      context.read<CommentsViewModel>().loadMoreComments();
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

    context.read<CommentsViewModel>().addComment(person: currentUser, text: text);

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
    final viewModel = context.watch<CommentsViewModel>();

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
  Widget _buildCommentsList(ThemeData theme, CommentsViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: SizedBox(height: 80, width: 80, child: IndeterminateLoadingIndicator()),
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
              child: SizedBox(height: 32, width: 32, child: IndeterminateLoadingIndicator()),
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
EOF

echo "-> patching widgets/post/mobile_post.dart"

python3 - <<'PYEOF'
import re

path = "widgets/post/mobile_post.dart"
with open(path, "r") as f:
    content = f.read()

old_import = "import 'package:redesigned/widgets/comment_sheet.dart';"
new_import = (
    "import 'package:redesigned/data/repositories/comment_repository.dart';\n"
    "import 'package:redesigned/screens/comments/comments_view_model.dart';\n"
    "import 'package:redesigned/widgets/comment_sheet.dart';"
)

if old_import not in content:
    raise SystemExit("Couldn't find the comment_sheet import in mobile_post.dart - bailing out so I don't mangle the file.")
if new_import not in content:
    content = content.replace(old_import, new_import, 1)

old_builder = """                          builder: (context, scrollController) {
                            return CommentSheet(
                              controller: scrollController,
                              postId: widget.post.postId,
                            );
                          },"""

new_builder = """                          builder: (context, scrollController) {
                            return ChangeNotifierProvider<CommentsViewModel>(
                              create: (context) => CommentsViewModel(
                                context.read<CommentsRepository>(),
                                widget.post.postId,
                              ),
                              child: CommentSheet(
                                controller: scrollController,
                                postId: widget.post.postId,
                              ),
                            );
                          },"""

if old_builder not in content:
    raise SystemExit("Couldn't find the CommentSheet builder block in mobile_post.dart - it may have already been patched, or the file has changed. Check manually.")

content = content.replace(old_builder, new_builder, 1)

with open(path, "w") as f:
    f.write(content)
PYEOF

echo "-> done"
echo ""
echo "Changed/added:"
echo "  screens/comments/comments_view_model.dart  (new)"
echo "  widgets/comment_sheet.dart                 (rewritten)"
echo "  widgets/post/mobile_post.dart               (patched)"
echo ""
echo "Run 'flutter analyze' and take a look at the diff before committing."