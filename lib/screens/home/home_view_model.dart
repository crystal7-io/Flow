import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/repositories/feed_repository.dart';
import 'package:redesigned/screens/home/home_data.dart';
import 'package:redesigned/core/services/app_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AppService _appService;

  final FeedRepository _feedRepository;

  final ScrollController scrollController = ScrollController();

  double _lastScrollOffset = 0;

  /// Checks if feed is being loaded
  /// Used to show skeletons when app opens
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  /// Checks if next feed items are being loaded
  /// Used to show loading indicator when scrolling down
  /// while next feed items are being fetch
  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;

  /// Checks if there are most posts available to show to user
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  List<List<dynamic>> get storiesData => li;

  String get profilePictureLink => linkToPfp;

  HomeViewModel(this._appService, this._feedRepository) {
    scrollController.addListener(_onScroll);
    getNewFeed();
  }

  /// Resets feed with new feed items
  Future<void> refreshFeed() async {
    _allowRefresh = false;
    notifyListeners();
    try {
      _posts = List<Post>.from(await _feedRepository.refreshFeedData());
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching feed: $e");
      }
    } finally {
      _isLoading = false;
      _hasMoreData = true;
      _allowRefresh = true;
      notifyListeners();
    }
  }

  /// Adds new Posts to Feed
  Future<void> getNewFeed() async {
    // This condition prevents spam of fetch requests
    if (_isLoadingNextPage || !_hasMoreData) return;

    _isLoadingNextPage = true;
    notifyListeners();

    try {
      final newPosts = await _feedRepository.getFeedData(_posts.length);

      // If new data is empty, the feed has reached its limit
      // To prevent further fetch requests, set [_hasMoreData] to false
      if (newPosts.isEmpty) {
        _hasMoreData = false;
      } else {
        _posts.addAll(newPosts);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching feed: $e");
      }
    } finally {
      _isLoadingNextPage = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _allowRefresh = true;
  bool get allowRefresh => _allowRefresh;

  void _onScroll() {
    final currentOffset = scrollController.offset;
    final delta = currentOffset - _lastScrollOffset;

    if (delta > 10) {
      // Scrolled down
      _appService.setNavBarVisible(false);
    } else if (delta < -10) {
      // Scrolled up
      _appService.setNavBarVisible(true);
    }

    // If the user is mid-feed, lock physics to clamp the momentum hard at 0.0
    if (currentOffset > 0 && _allowRefresh) {
      _allowRefresh = false;
      notifyListeners();
    }
    // Only unlock bouncing once the list settles entirely at the top edge
    else if (currentOffset <= 0 && !_allowRefresh) {
      _allowRefresh = true;
      notifyListeners();
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    // Triggers when the user is within 200 pixels of the bottom boundary\
    // This will be used to get new set of feed items
    if (maxScroll - currentOffset <= 200) {
      getNewFeed();
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  final Set<Filters> _selectedFilters = <Filters>{};
  Set<Filters> get selectedFilters => _selectedFilters;

  void toggleFilter(Filters filter, bool selected) {
    if (selected) {
      _selectedFilters.add(filter);
    } else {
      _selectedFilters.remove(filter);
    }
    notifyListeners();
  }

  void onSearchTap() {
    // TODO: Search bar tapped
  }

  void onMicPressed() {
    // TODO: Mic pressed
  }

  void onSwitchButtonPressed() {
    // TODO: onNewPostPress
  }
}
