import 'package:isar/isar.dart';
import 'package:redesigned/core/models/like/post_like.dart';

/// Handles the operations related Post Database like Likes, Comments, etc
class PostDataSource {
  Isar get isar => Isar.getInstance()!;

  PostDataSource();

  /// toggles a like in Likes table;
  Future<void> toggleLike({required String userId, required String postId}) async {
    // 1. Find if the user already liked this post
    final existingLike = await isar.postLikes
        .filter()
        .userIdEqualTo(userId)
        .and()
        .postIdEqualTo(postId)
        .findFirst();

    await isar.writeTxn(() async {
      if (existingLike != null) {
        // Delete the record if like exist
        await isar.postLikes.delete(existingLike.id);
      } else {
        // Create the record if like don't exist
        await isar.postLikes.put(
          PostLike(userId: userId, postId: postId, createdAt: DateTime.now()),
        );
      }
    });
  }
}
