import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/remote/comments_data_source.dart';

/// Repository handling business logic and data coordination for post comments.
///
/// Acts as the single source of truth for comment threads, bridging the UI layer
/// with [CommentsDataSource] to perform CRUD operations, likes, and reply handling.
class CommentsRepository {
  final CommentsDataSource _commentsDataSource;

  CommentsRepository(this._commentsDataSource);

  /// Fetches a paginated list of top-level comments for a given [postId].
  Future<List<Comment>> getCommentsForPost({
    required String postId,
    DateTime? lastDateTime,
    int limit = 10,
  }) async {
    return await _commentsDataSource.fetchCommentsForPost(
      postId: postId,
      lastDateTime: lastDateTime,
      limit: limit,
    );
  }

  /// Adds a new top-level comment to a post thread.
  Future<Comment> addComment({
    required String postId,
    required Person person,
    required String text,
    String? replyToCommentId,
  }) async {
    // Generate a unique client-side comment ID
    final generatedCommentId = 'c_${postId}_${DateTime.now().millisecondsSinceEpoch}';

    final comment = Comment(
      commentId: generatedCommentId,
      postId: postId,
      person: person,
      text: text,
      dateTime: DateTime.now().toIso8601String(),
      replyToCommentId: replyToCommentId,
      likes: 0,
      isLiked: false,
    );

    await _commentsDataSource.addComment(postId: postId, comment: comment);

    return comment;
  }

  /// Toggles a like to a comment
  Future<void> toggleCommentLike({required String commentId, required String userId}) async {
    await _commentsDataSource.toggleLike(userId: userId, commentId: commentId);
  }
}
