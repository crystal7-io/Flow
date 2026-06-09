// ignore_for_file: constant_identifier_names
import 'package:redesigned/core/models/models.dart';
import 'package:redesigned/data/mock_data.dart'; // Assuming Post, Person are defined here

// Enum for filters
enum Filters { Popular, Arts, Music, Funny, Cats, Cooking, Memes }

// Placeholder for posts data
// You'll need to define `posts` based on your `Post` class structure.
// For now, I'll use a simplified list of strings. Replace this with your actual Post objects.
final List<Post> posts = [
  // Example:
  // Post(id: '1', content: 'First post content', imageUrl: '...', type: PostType.image),
  // Post(id: '2', content: 'Second post content', imageUrl: '...', type: PostType.carosel),
];
// Make sure your Post class is imported and correctly defined for the above.
// As a placeholder for demonstration, let's assume `Post` is just a string.
// If your `Post` is more complex, ensure it's imported and the list populated correctly.
// For this example, I'll make a dummy list:
List<Post> get dummyPosts => <Post>[
  CarouselPostObject(
    postId: 001,
    person: accounts[8].person,
    subTitle: "Lost in the intricate details of this architectural masterpiece",
    aspectRatio: 1 / 1,
    imagePaths: [
      "1swN0I0kJVE-YogucSzCcObVkdQ-ORnh2",
      "10wPKtmDBC8ylKcqWplQ3LOtreucDkxAN",
      "1m6RJ8X1uYkidux5XkDixn1jFRu8IXqTH",
    ],
    tags: [],
    type: PostType.carosel,
    dateTime: DateTime(2024, 3, 24, 4, 25, 34),
  ),
  // ReelPostObject(
  //   aspectRatio: 5 / 4,
  //   postId: 002,
  //   person: accounts[22].person,
  //   subTitle: "Beautiful cloud mountain scenery",
  //   sourcePath: "1n6UUe6Yk1ZTB5DKP55lP6CNZia7_r7KE",
  //   type: PostType.reel,
  //   dateTime: DateTime(2024, 3, 16, 5, 24, 54),
  // ),
  ImagePostObject(
    postId: 003,
    aspectRatio: 1,
    person: accounts[9].person,
    subTitle: "A Night view through my window",
    imagePath: "1JpcQdKOF3N2MJe00fSvvjSxAvhdbLAo4",
    type: PostType.image,
    tags: ["furina_sunshine", "furina", "hydro archon"],
    dateTime: DateTime(2024, 3, 14, 6, 24, 14),
  ),
  CarouselPostObject(
    type: PostType.carosel,
    aspectRatio: 3 / 2.5,
    person: accounts[19].person,
    imagePaths: [
      "1uVVJIsFQT-qz23Nph1rzZt_a7qwDQqI9",
      "1VFPF46ib6BmpNb18t5ovY4swmk_wuwq9",
      "1O5rHhl8yg5XhPWdhddAu1Bw2VRyrWH43",
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
    postId: 005,
    person: accounts[10].person,
    subTitle:
        "A wonderful scenery of hot air balloon . I wish I could visit there someday.",
    imagePath: "1VyZJ9yYhXcw-wCxsItBulgl3ARzTjALo",
    aspectRatio: 4 / 5,
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
  ImagePostObject(
    aspectRatio: 0.9375,
    postId: 006,
    person: accounts[27].person,
    subTitle:
        "Ready to dive in?  Immerse yourself in breathtaking VR worlds. Explore our VR offers.",
    imagePath: "1HURvDDRB2QxF7z2vFnLQ6KnFxDI4Xryn",
    type: PostType.image,
    dateTime: DateTime(2024, 3, 16, 5, 24, 54),
  ),
];

// You'll need to properly define your Post class and populate 'posts' with actual Post objects.

// Placeholder for li (stories data)
final List<List<dynamic>> li = [
  ["furina.sunshine", "Furina de Fontaine", "images/furina.png", 4],
  ["cook.with.shogun", "Raiden Shogun", "images/raiden.png", 0],
  ["director_hu54", "Director Hu", "images/hutao.png", 2],
  ["guji_yae", "Yae Miko", "images/yaemiko.png", 0],
  ["alcohol.is.not.for.kidz", "Whos This Guy", "images/venti.png", 3],
  ["i_love_boba", "Kamisato Ayato", "images/ayato.png", 1],
  ["the.bull.chucker", "Arataki Itto", "images/itto.png", 0],
  ["not.a.child", "Tartaglia", "images/childe.png", 0],
];

// Placeholder for linkToPfp
const String linkToPfp =
    'https://drive.google.com/uc?export=view&id=1LB2B4h_hzLjZUb7AWAS8XNkrVa9JQ1yu'; // Replace with a real link or asset path
