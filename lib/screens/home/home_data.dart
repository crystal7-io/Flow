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
    person: accounts[16].person,
    subTitle: "Lost in the intricate details of this architectural masterpiece",
    aspectRatio: 1 / 1,
    likes: 2402000,
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
    likes: 240220,
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
    type: PostType.image,
    tags: [],
    dateTime: DateTime(2024, 4, 28, 08, 12, 10),
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
