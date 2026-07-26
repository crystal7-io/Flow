import 'package:redesigned/data/remote/post_data_source.dart';

/// Handles the post actions like Like, Comment, Saving a post, etc
class PostRepository {
  final PostDataSource _postDataSource;
  PostRepository(this._postDataSource);

  ///This function is used to like a Post with ID given in argument.
  /// Returns a bool based on it's success.
  void toggleLikeOnPostWithID({required String userId, required String postId}) {
    _postDataSource.toggleLike(userId: userId, postId: postId);
  }
}
