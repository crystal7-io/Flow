import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:redesigned/core/constants/json_file_paths.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/core/models/like/comment_like.dart';

/// Data source responsible for executing local disk-level operations
/// and simulating remote API responses for comment data using Isar database.
///
/// Handles low-level persistence, cursor pagination, and seeding of comments.
class CommentsDataSource {
  /// Constructor initializes and seeds the Isar database if empty.
  CommentsDataSource() {
    _seedInitialCommentsIfNeeded();
  }

  /// Fetches a paginated list of top-level comments for a specific [postId]
  /// using cursor-based pagination.
  ///
  /// Pass [lastDateTime] = `null` for the first page.
  /// For subsequent pages, pass the [parsedDateTime] of the last comment from the previous batch.
  Future<List<Comment>> fetchCommentsForPost({
    required String postId,
    DateTime? lastDateTime,
    int limit = 10,
  }) async {
    // Delay to mimic network/disk fetch
    await Future.delayed(const Duration(milliseconds: 1200));

    final isar = Isar.getInstance();
    if (isar == null) return [];

    // 1. Fetch liked comment IDs for the current user to map `isLiked` state
    final Set<String> likedCommentIds =
        (await isar.commentLikes.where().commentIdProperty().findAll()).toSet();

    // 2. Query Isar directly for comments matching postId
    QueryBuilder<Comment, Comment, QAfterFilterCondition> query = isar.comments
        .filter()
        .postIdEqualTo(postId);

    // 3. Apply cursor filter: fetch comments created before lastDateTime
    if (lastDateTime != null) {
      query = query.parsedDateTimeLessThan(lastDateTime);
    }

    // 4. Fetch sorted by newest first with limit
    final commentsList = await query.sortByParsedDateTimeDesc().limit(limit).findAll();

    // 5. Sync runtime `isLiked` state using commentId
    for (final comment in commentsList) {
      comment.isLiked = likedCommentIds.contains(comment.commentId);
    }

    return commentsList;
  }

  /// Adds a new comment directly to Isar storage.
  Future<void> addComment({required String postId, required Comment comment}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final isar = Isar.getInstance();
    if (isar == null) return;

    comment.postId = postId;

    await isar.writeTxn(() async {
      await isar.comments.put(comment);
    });
  }

  /// Private method to seed initial mock comments from JSON asset into Isar on first launch.
  Future<void> _seedInitialCommentsIfNeeded() async {
    final isar = Isar.getInstance();
    if (isar == null) return;

    // Check if comments are already populated
    final count = await isar.comments.count();
    if (count > 0) return;

    try {
      // 1. Load raw JSON string from assets
      final jsonString = await rootBundle.loadString(JsonFilePaths.commentsJson);

      // 2. Decode string into a list of dynamic JSON maps
      final List<dynamic> rawJsonList = jsonDecode(jsonString) as List<dynamic>;

      // 3. Convert JSON list to List<Comment> using Comment.fromJson
      final List<Comment> initialComments = rawJsonList
          .map((json) => Comment.fromJson(json as Map<String, dynamic>))
          .toList();

      // 4. Batch insert into Isar storage
      await isar.writeTxn(() async {
        await isar.comments.putAll(initialComments);
      });
    } catch (e) {
      // Handles missing assets, bad JSON format, or parsing errors gracefully
      assert(false, 'Failed to seed comments from JSON asset: $e');
    }
  }
}
