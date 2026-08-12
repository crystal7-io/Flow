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
class CommentViewModel extends ChangeNotifier {
  final CommentsRepository _commentsRepository;
  final String postId;

  /// UserId of currently logged in user.
  /// It will be used to add the userId to Comments and CommentLike
  final String currentUserId;

  CommentViewModel({
    required this._commentsRepository,
    required this.postId,
    required this.currentUserId,
  }) {
    getInitialComments();
  }

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  /// IDs of comments the current user has liked. Kept alongside
  /// Comment.isLiked (rather than as the only source of truth) since the
  /// list is what actually gets rendered - this is here mainly so the UI
  /// can do quick "is this id liked" checks without scanning _comments.
  final Set<String> _likedCommentIds = {};
  Set<String> get likedCommentIds => _likedCommentIds;

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
      _likedCommentIds
        ..clear()
        ..addAll(_comments.where((c) => c.isLiked).map((c) => c.commentId));
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
        _likedCommentIds.addAll(nextPage.where((c) => c.isLiked).map((c) => c.commentId));
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

  /// Toggles like state for [commentId]. Updates the UI immediately
  /// (optimistic), then calls the repository, which checks the DB itself
  /// to decide whether to like or unlike. If the repository call fails,
  /// the change is rolled back so the UI doesn't end up showing a like that
  /// never actually got persisted.
  Future<void> toggleCommentLike(String commentId) async {
    final index = _comments.indexWhere((c) => c.commentId == commentId);
    if (index == -1) return;

    final comment = _comments[index];
    final wasLiked = comment.isLiked;

    // Optimistic update - flip immediately so the tap feels instant.
    comment.isLiked = !wasLiked;
    comment.likes += wasLiked ? -1 : 1;
    if (comment.isLiked) {
      _likedCommentIds.add(commentId);
    } else {
      _likedCommentIds.remove(commentId);
    }
    notifyListeners();

    try {
      await _commentsRepository.toggleCommentLike(userId: currentUserId, commentId: commentId);
    } catch (e) {
      // Roll back on failure so UI matches what's actually persisted.
      comment.isLiked = wasLiked;
      comment.likes += wasLiked ? 1 : -1;
      if (wasLiked) {
        _likedCommentIds.add(commentId);
      } else {
        _likedCommentIds.remove(commentId);
      }
      notifyListeners();
    }
  }
}
