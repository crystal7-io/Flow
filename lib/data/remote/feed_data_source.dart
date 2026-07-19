import 'package:collection/collection.dart';
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart';

/// This class handles fetching feed data from remote data source.
/// But as I don't have any Data Source right now, I will make use of mock data locally to send
/// with a delay to make it mimic fetching from network.
class FeedDataSource {
  /// Constructor will initialize a randomized [List<Post>] instance.
  /// This will be used as feedCache
  FeedDataSource() {
    setNewFeedCache();
  }

  /// This holds a randomized feed data instance.
  /// Every time [fetchFeedData] is called, it will provide next set of feed items.
  /// This way, feed is paginated.
  /// Real life social media apps hold a Feed Cache for each user which is used to provide feed
  /// data to users. I don't have a server so this is a workaround for it.
  List<Post> _feedCache = [];

  /// Return [List<Post>] for Feed
  Future<List<Post>> fetchFeedData(int newIndex) async {
    // Delay to mimic data fetching;
    await Future.delayed(Duration(milliseconds: 1200));

    // Ensure we don't slice past the end of the array
    final int end = (newIndex + 5).clamp(0, _feedCache.length);

    // Return next items based on index provided;
    return _feedCache.slice(newIndex, end);
  }

  /// This method will reset the feed and return a first set of Post items
  Future<List<Post>> refreshFeedData() async {
    // Reset Feed Cache
    setNewFeedCache();

    // Send a new set of feed
    return await fetchFeedData(0);
  }

  /// This private method is used to reset [_feedCache] to a new shuffled feed data
  void setNewFeedCache() {
    _feedCache = dummyPosts..shuffle();
  }
}

List<Post> get dummyPosts => <Post>[
  CarouselPostObject(
    postId: 001,
    person: accounts[16].person,
    subTitle: "Lost in the intricate details of this architectural masterpiece",
    aspectRatio: 1 / 1,
    likes: 8432910,
    imagePaths: [
      "https://drive.google.com/uc?export=view&id=1swN0I0kJVE-YogucSzCcObVkdQ-ORnh2",
      "https://drive.google.com/uc?export=view&id=10wPKtmDBC8ylKcqWplQ3LOtreucDkxAN",
      "https://drive.google.com/uc?export=view&id=1m6RJ8X1uYkidux5XkDixn1jFRu8IXqTH",
    ],
    tags: [],
    type: PostType.carosel,
    dateTime: DateTime(2024, 3, 24, 4, 25, 34),
  ),
  ImagePostObject(
    postId: 003,
    aspectRatio: 1,
    person: accounts[9].person,
    subTitle: "A Night view through my window",
    imagePath: "https://drive.google.com/uc?export=view&id=1JpcQdKOF3N2MJe00fSvvjSxAvhdbLAo4",
    likes: 124503,
    type: PostType.image,
    tags: ["furina_sunshine", "furina", "hydro archon"],
    dateTime: DateTime(2024, 3, 14, 6, 24, 14),
  ),
  ImagePostObject(
    postId: 005,
    person: accounts[10].person,
    subTitle: "A wonderful scenery of hot air balloon . I wish I could visit there someday.",
    imagePath: "https://drive.google.com/uc?export=view&id=1VyZJ9yYhXcw-wCxsItBulgl3ARzTjALo",
    aspectRatio: 4 / 5,
    likes: 5693001,
    type: PostType.image,
    tags: [
      "#rip",
      "#gonebutnotforgotten",
      "#foreverinourhearts",
      "#flyhigh",
      "#inlovingmemory",
      "#restinpeace",
      "#celebratinglife",
      "#funeral",
      "#service",
      "#memorial",
    ],
    dateTime: DateTime(2024, 3, 16, 5, 24, 54),
  ),
  CarouselPostObject(
    type: PostType.carosel,
    aspectRatio: 3 / 2.5,
    person: accounts[19].person,
    likes: 34105,
    imagePaths: [
      "https://drive.google.com/uc?export=view&id=1uVVJIsFQT-qz23Nph1rzZt_a7qwDQqI9",
      "https://drive.google.com/uc?export=view&id=1VFPF46ib6BmpNb18t5ovY4swmk_wuwq9",
      "https://drive.google.com/uc?export=view&id=1O5rHhl8yg5XhPWdhddAu1Bw2VRyrWH43",
    ],
    dateTime: DateTime(2024, 2, 23, 3, 43, 21),
    postId: 004,
    subTitle: "Today's dish, mouth watering fried rice.",
    tags: [
      "#food",
      "#yummy",
      "#delicious",
      "#homecooking",
      "#foodlover",
      "#foodgasm",
      "#chef",
      "#cooking",
      "#recipe",
      "#healthyfood",
      "#homemade",
      "#foodblog",
      "#dinner",
      "#lunch",
      "#breakfast",
      "#vegetarian",
      "#vegan",
    ],
  ),
  ImagePostObject(
    aspectRatio: 0.9375,
    postId: 006,
    person: accounts[27].person,
    subTitle:
        "Ready to dive in?  Immerse yourself in breathtaking VR worlds. Explore our VR offers.",
    imagePath: "https://drive.google.com/uc?export=view&id=1HURvDDRB2QxF7z2vFnLQ6KnFxDI4Xryn",
    likes: 9224150,
    type: PostType.image,
    dateTime: DateTime(2024, 3, 16, 5, 24, 54),
  ),
  ImagePostObject(
    postId: 007,
    aspectRatio: 16 / 9,
    person: accounts[5].person,
    subTitle: "Chasing sunsets on the open road.",
    imagePath:
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&fm=webp&auto=format,compress",
    likes: 411032,
    type: PostType.image,
    tags: [],
    dateTime: DateTime(2024, 4, 02, 18, 30, 00),
  ),
  CarouselPostObject(
    postId: 008,
    type: PostType.carosel,
    aspectRatio: 4 / 3,
    person: accounts[12].person,
    subTitle: "A weekend well spent coding and drinking coffee.",
    imagePaths: [
      "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1510915228340-29c85a43dcfe?w=800&fm=webp&auto=format,compress",
    ],
    likes: 725400,
    tags: [],
    dateTime: DateTime(2024, 4, 05, 11, 15, 22),
  ),
  ImagePostObject(
    postId: 009,
    aspectRatio: 1,
    person: accounts[15].person,
    subTitle: "My morning routine looks like this now.",
    imagePath:
        "https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=800&fm=webp&auto=format,compress",
    likes: 3892014,
    type: PostType.image,
    tags: [],
    dateTime: DateTime(2024, 4, 10, 07, 45, 10),
  ),
  CarouselPostObject(
    postId: 010,
    type: PostType.carosel,
    aspectRatio: 1 / 1,
    person: accounts[22].person,
    subTitle: "Snapshots from yesterday's hike up the mountain.",
    imagePaths: [
      "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=800&fm=webp&auto=format,compress",
    ],
    likes: 54120,
    tags: [],
    dateTime: DateTime(2024, 4, 12, 14, 20, 05),
  ),
  ImagePostObject(
    postId: 011,
    aspectRatio: 4 / 5,
    person: accounts[21].person,
    subTitle: "Finally finished reading this masterpiece.",
    imagePath:
        "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=800&fm=webp&auto=format,compress",
    likes: 6734992,
    type: PostType.image,
    tags: [],
    dateTime: DateTime(2024, 4, 15, 21, 10, 40),
  ),
  CarouselPostObject(
    postId: 012,
    type: PostType.carosel,
    aspectRatio: 1,
    person: accounts[2].person,
    subTitle: "Stargazing on a clear summer night. The universe is massive.",
    imagePaths: [
      "https://images.unsplash.com/photo-1506318137071-a8e063b4bec0?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1538370965046-79c0d6907d47?w=800&fm=webp&auto=format,compress",
    ],
    likes: 21045,
    tags: [],
    dateTime: DateTime(2024, 4, 18, 23, 15, 00),
  ),
  CarouselPostObject(
    postId: 013,
    type: PostType.carosel,
    aspectRatio: 4 / 5,
    person: accounts[7].person,
    subTitle: "Pluviophile. Loving this rainy day vibe.",
    imagePaths: [
      "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=800&fm=webp&auto=format,compress",
    ],
    likes: 4983115,
    tags: [],
    dateTime: DateTime(2024, 4, 20, 10, 05, 14),
  ),
  CarouselPostObject(
    postId: 014,
    type: PostType.carosel,
    aspectRatio: 4 / 5,
    person: accounts[14].person,
    subTitle: "Nothing beats a clean, minimalist workspace.",
    imagePaths: [
      "https://images.unsplash.com/photo-1499955085172-a104c9463ece?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&fm=webp&auto=format,compress",
    ],
    likes: 850322,
    tags: [],
    dateTime: DateTime(2024, 4, 22, 09, 30, 45),
  ),
  CarouselPostObject(
    postId: 015,
    type: PostType.carosel,
    aspectRatio: 4 / 3,
    person: accounts[18].person,
    subTitle: "Exploring the hidden alleys of Kyoto.",
    imagePaths: [
      "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1542051841857-5f90071e7989?w=800&fm=webp&auto=format,compress",
      "https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800&fm=webp&auto=format,compress",
    ],
    likes: 7120459,
    tags: [],
    dateTime: DateTime(2024, 4, 25, 16, 40, 22),
  ),
  ImagePostObject(
    postId: 016,
    aspectRatio: 1.2,
    person: accounts[26].person,
    subTitle: "Freshly baked sourdough bread out of the oven!",
    imagePath:
        "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?w=800&fm=webp&auto=format,compress",
    likes: 104230,
    type: PostType.image,
    tags: [],
    dateTime: DateTime(2024, 4, 28, 08, 12, 10),
  ),
];
