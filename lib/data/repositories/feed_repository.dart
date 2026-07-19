import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/remote/feed_data_source.dart';

/// This class Handles Feed Data
class FeedRepository {
  final FeedDataSource _feedDataSource;
  FeedRepository(this._feedDataSource);

  /// Fetch 5 feed items <- UNDER WORK
  Future<List<Post>> getFeedData(int lastIndex) {
    return _feedDataSource.fetchFeedData(lastIndex);
  }

  /// Fetches fresh new feed items.
  /// This method will reset the user feed
  Future<List<Post>> refreshFeedData() {
    return _feedDataSource.refreshFeedData();
  }
}
