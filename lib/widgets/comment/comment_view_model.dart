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

  CommentViewModel(this._commentsRepository, this.postId) {
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
