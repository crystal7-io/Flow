import 'package:redesigned/core/models/account.dart';
import 'package:redesigned/core/models/chat.dart';
import 'package:redesigned/core/models/comment.dart';
import 'package:redesigned/core/models/notification.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/core/models/post.dart';
import 'package:redesigned/core/models/reel_model.dart';
import 'package:redesigned/core/models/story.dart';

List<FollowPerson> followersList = [
  FollowPerson(
    id: '12',
    name: accounts[12].person.name,
    userName: accounts[12].person.userName,
    profilePicturePath: accounts[12].person.profilePicturePath,
    isFollowing: true,
  ),
  FollowPerson(
    id: '14',
    name: accounts[14].person.name,
    userName: accounts[14].person.userName,
    profilePicturePath: accounts[14].person.profilePicturePath,
    isFollowing: true,
  ),
  FollowPerson(
    id: '15',
    name: accounts[15].person.name,
    userName: accounts[15].person.userName,
    profilePicturePath: accounts[15].person.profilePicturePath,
    isFollowing: false,
  ),
  FollowPerson(
    id: '16',
    name: accounts[16].person.name,
    userName: accounts[16].person.userName,
    profilePicturePath: accounts[16].person.profilePicturePath,
    isFollowing: true,
  ),
  FollowPerson(
    id: '4',
    name: accounts[4].person.name,
    userName: accounts[4].person.userName,
    profilePicturePath: accounts[4].person.profilePicturePath,
    isFollowing: true,
  ),
  FollowPerson(
    id: '6',
    name: accounts[6].person.name,
    userName: accounts[6].person.userName,
    profilePicturePath: accounts[6].person.profilePicturePath,
    isFollowing: true,
  ),
  FollowPerson(
    id: '19',
    name: accounts[19].person.name,
    userName: accounts[19].person.userName,
    profilePicturePath: accounts[19].person.profilePicturePath,
    isFollowing: false,
  ),
  FollowPerson(
    id: '11',
    name: accounts[11].person.name,
    userName: accounts[11].person.userName,
    profilePicturePath: accounts[11].person.profilePicturePath,
    isFollowing: false,
  ),
  FollowPerson(
    id: '23',
    name: accounts[23].person.name,
    userName: accounts[23].person.userName,
    profilePicturePath: accounts[23].person.profilePicturePath,
    isFollowing: false,
  ),
];

List<Post> posts = <Post>[
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
  ReelPostObject(
    aspectRatio: 5 / 4,
    postId: 002,
    person: accounts[22].person,
    subTitle: "Beautiful cloud mountain scenery",
    sourcePath: "https://drive.google.com/uc?export=view&id=1n6UUe6Yk1ZTB5DKP55lP6CNZia7_r7KE",
    type: PostType.reel,
    dateTime: DateTime(2024, 3, 16, 5, 24, 54),
  ),
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
];

Post getPostFromPostID(int id) {
  for (var element in posts) {
    if (element.postId == id) {
      return element;
    }
  }
  throw Exception("POST NOT FOUND : $id");
}

List<List<Comment>> comments = [
  [
    Comment(
      person: accounts[17].person,
      text: "Wow, absolutely incredible work! This made my day.",
      dateTime: "8 min",
      replies: <CommentReply>[
        CommentReply(
          replyTo: accounts[25].person.userName,
          person: accounts[21].person,
          text: "Ysss",
          dateTime: DateTime(2024, 3, 4, 12, 24, 4),
        ),
        CommentReply(
          replyTo: accounts[25].person.userName,
          person: accounts[12].person,
          text: "Mayb yess",
          dateTime: DateTime(2024, 3, 4, 12, 24, 4),
        ),
        CommentReply(
          replyTo: accounts[25].person.userName,
          person: accounts[15].person,
          text: "This can be a serious thing if you think logically about it.",
          dateTime: DateTime(2024, 3, 4, 12, 24, 4),
        ),
        CommentReply(
          replyTo: accounts[25].person.userName,
          person: accounts[16].person,
          text: "Lmaooo 😭",
          dateTime: DateTime(2024, 3, 4, 12, 24, 4),
        ),
        CommentReply(
          replyTo: accounts[25].person.userName,
          person: accounts[18].person,
          text: "Agreed",
          dateTime: DateTime(2024, 3, 4, 12, 24, 4),
        ),
      ],
    ),

    Comment(
      person: accounts[5].person,
      text: "Honestly, I am such a huge fan of everything you do. Keep pushing forward! 🚀",
      dateTime: "18 min",
    ),
    Comment(person: accounts[13].person, text: "Good work!!", dateTime: "26 min"),
    Comment(
      person: accounts[11].person,
      text: "This is exactly what I needed to see today. Brilliant stuff.",
      dateTime: "39 min",
    ),
    Comment(person: accounts[0].person, text: "So inspiring honestly.", dateTime: "42 min"),
    Comment(
      person: accounts[22].person,
      text: "The dedication here is unmatched. Seriously impressive results!",
      dateTime: "45 min",
    ),
    Comment(person: accounts[7].person, text: "Love this so much!", dateTime: "51 min"),
    Comment(
      person: accounts[19].person,
      text: "You can really tell how much effort went into this. Outstanding job!",
      dateTime: "58 min",
    ),
    Comment(person: accounts[3].person, text: "Pure perfection 💯", dateTime: "1 hr"),
    Comment(
      person: accounts[6].person,
      text: "Count me in as a lifelong supporter, this is legendary.",
      dateTime: "1 hr",
    ),
    Comment(person: accounts[1].person, text: "Keep it up!", dateTime: "2 hr"),
    Comment(
      person: accounts[14].person,
      text: "I've been following your journey for a while and you just keep getting better.",
      dateTime: "2 hr",
    ),
    Comment(
      person: accounts[8].person,
      text: "Such a vibe, love the energy here.",
      dateTime: "3 hr",
    ),
    Comment(
      person: accounts[2].person,
      text: "This deserves way more recognition. Amazing work!",
      dateTime: "3 hr",
    ),
    Comment(person: accounts[12].person, text: "So clean!", dateTime: "4 hr"),
    Comment(
      person: accounts[26].person,
      text: "You genuinely inspire me to work harder. Thank you for sharing this!",
      dateTime: "4 hr",
    ),
    Comment(person: accounts[4].person, text: "Simply awesome 🙌", dateTime: "5 hr"),
  ],
];

List<List<Notif>> notifications = [
  [
    StoryLikeNotification(
      notifier: accounts[0].person,
      time: '5 min',
      storyNum: 1,
      contextImagePath: myStories[1].pathToMedia,
    ),
    FollowNotification(
      notifier: accounts[23].person,
      time: '2 hr',
      contextImagePath: myStories[0].pathToMedia,
    ),
    CommentLikeNotficaiton(
      notifier: accounts[21].person,
      time: '24 min',
      postID: 001,
      commentText: comments[0][1].text,
      contextImagePath: getPostFromPostID(001).coverImagePath,
    ),
    StoryLikeNotification(
      notifier: accounts[16].person,
      time: '12 min',
      storyNum: 0,
      contextImagePath: myStories[0].pathToMedia,
    ),
  ],
  [
    CommentReplyNotficaiton(
      notifier: accounts[18].person,
      time: '34 min',
      reply: "Yes, that's what I thought",
      commentText: "Hey, this looks just like the previous post",
      postID: 001,
      isLiked: false,
      contextImagePath: getPostFromPostID(001).coverImagePath,
    ),
    StoryLikeNotification(
      notifier: accounts[14].person,
      time: '16 min',
      storyNum: 1,
      contextImagePath: myStories[1].pathToMedia,
    ),
    CommentLikeNotficaiton(
      notifier: accounts[2].person,
      time: '3 min',
      postID: 002,
      commentText: comments[0][0].text,
      contextImagePath: getPostFromPostID(002).coverImagePath,
    ),
    StoryLikeNotification(
      notifier: accounts[10].person,
      time: '46 min',
      storyNum: 0,
      contextImagePath: myStories[0].pathToMedia,
    ),
    CommentLikeNotficaiton(
      notifier: accounts[8].person,
      time: '5 hr',
      postID: 001,
      commentText: comments[0][1].text,
      contextImagePath: getPostFromPostID(001).coverImagePath,
    ),
    PostLikeNotification(
      notifier: accounts[4].person,
      time: '9 hr',
      postID: 002,
      contextImagePath: getPostFromPostID(002).coverImagePath,
    ),
  ],
  [
    StoryLikeNotification(
      notifier: accounts[9].person,
      time: '1 day',
      storyNum: 1,
      contextImagePath: myStories[1].pathToMedia,
    ),
    CommentLikeNotficaiton(
      notifier: accounts[0].person,
      time: '1 day',
      postID: 004,
      commentText: comments[0][1].text,
      contextImagePath: getPostFromPostID(004).coverImagePath,
    ),
    PostLikeNotification(
      notifier: accounts[6].person,
      time: '1 day',
      postID: 002,
      contextImagePath: getPostFromPostID(002).coverImagePath,
    ),
    StoryLikeNotification(
      notifier: accounts[12].person,
      time: '1 day',
      storyNum: 1,
      contextImagePath: myStories[1].pathToMedia,
    ),
    CommentLikeNotficaiton(
      notifier: accounts[3].person,
      time: '1 day',
      postID: 003,
      commentText: comments[0][0].text,
      contextImagePath: getPostFromPostID(003).coverImagePath,
    ),
  ],
];

List<String> downloadImages = [
  "https://img.freepik.com/free-photo/sunset-savannah_1048-4710.jpg?t=st=1713011145~exp=1713014745~hmac=c6681071fb5d115bd6169c2480887907acedd17e0b76976fe4bfb91a017a5070&w=1060",
];

List<Chat> chats = [
  Chat(
    person: accounts[13].person,
    newMessage: 2,
    lastMessage: "Yup, saw that too !",
    lastTime: "16:23",
    isActive: true,
  ),
  Chat(
    person: accounts[24].person,
    newMessage: 3,
    lastMessage: "Wake up sleepy head",
    lastTime: "13:35",
    isActive: true,
  ),
  Chat(person: accounts[12].person, newMessage: 0, lastMessage: "Byee!!!", lastTime: "10:23"),
  Chat(
    person: accounts[21].person,
    newMessage: 1,
    lastMessage: "A human gave me a flower today, do you know what to do with this ?",
    lastTime: "10:04",
    isActive: true,
  ),
  Chat(
    person: accounts[17].person,
    newMessage: 3,
    lastMessage: "How do you cook this ?",
    lastTime: "6:24",
  ),
  Chat(
    person: accounts[10].person,
    newMessage: 0,
    lastMessage: "Good Night~",
    lastMessageState: LastMessageState.sentByUserAndSeen,
    lastTime: "1 day",
  ),
  Chat(
    person: accounts[28].person,
    newMessage: 0,
    lastMessage: "I will be leaving now",
    lastTime: "1 day",
    isActive: true,
  ),
  Chat(
    person: accounts[9].person,
    newMessage: 0,
    lastMessage: "Alrighty!",
    lastMessageState: LastMessageState.sentByUserAndUnseen,
    lastTime: "2 day",
  ),
  Chat(
    person: accounts[27].person,
    newMessage: 2,
    lastMessageState: LastMessageState.sentByUserAndSeen,
    lastMessage: "Cya Later!",
    lastTime: "2 day",
  ),
  // 10 New Chats Added Below (avoiding 20 and 25):
  Chat(
    person: accounts[0].person,
    newMessage: 5,
    lastMessage: "Are you free right now?",
    lastTime: "18:45",
    isActive: true,
  ),
  Chat(
    person: accounts[1].person,
    newMessage: 0,
    lastMessage: "Sounds good to me.",
    lastMessageState: LastMessageState.sentByUserAndSeen,
    lastTime: "17:10",
  ),
  Chat(
    person: accounts[2].person,
    newMessage: 1,
    lastMessage: "Don't forget the documents!",
    lastTime: "15:30",
    isActive: true,
  ),
  Chat(person: accounts[3].person, newMessage: 0, lastMessage: "On my way!", lastTime: "14:15"),
  Chat(
    person: accounts[4].person,
    newMessage: 4,
    lastMessage: "Can you review this code?",
    lastTime: "11:50",
    isActive: true,
  ),
  Chat(
    person: accounts[5].person,
    newMessage: 0,
    lastMessage: "Thanks for the help!",
    lastMessageState: LastMessageState.sentByUserAndSeen,
    lastTime: "09:15",
  ),
  Chat(
    person: accounts[26].person,
    newMessage: 2,
    lastMessage: "Let's grab lunch tomorrow.",
    lastTime: "08:30",
  ),
  Chat(
    person: accounts[14].person,
    newMessage: 0,
    lastMessage: "Got it.",
    lastMessageState: LastMessageState.sentByUserAndUnseen,
    lastTime: "Yesterday",
  ),
  Chat(
    person: accounts[15].person,
    newMessage: 1,
    lastMessage: "Where are you?",
    lastTime: "Yesterday",
    isActive: true,
  ),
  Chat(
    person: accounts[23].person,
    newMessage: 0,
    lastMessage: "See you at the meeting.",
    lastMessageState: LastMessageState.sentByUserAndSeen,
    lastTime: "3 day",
  ),
];

List<Account> accounts = [
  Account(
    person: Person(
      id: '0',
      name: "Ethan Brown",
      userName: "EthanB_7",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1t8ON-QsNgAC1ry7OHNzBbG1uLiLIjES2',
      profilePictureShape: 'circle',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '1',
      name: "Lucas Anderson",
      userName: "lucas_ands1",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1Y0QB4V0MeyoRUO0QQZu5qFMhT7ajlxzb',
      profilePictureShape: 'heart',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '2',
      name: "Ayaka",
      userName: "am_i_ayaya",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1dlzU80M9PEuPhX2qKo1QpvsWyaXIcv-F',
      profilePictureShape: 'flower',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '3',
      name: "Jacob Miller",
      userName: "jack_mil_25",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1dlzU80M9PEuPhX2qKo1QpvsWyaXIcv-F',
      profilePictureShape: 'square',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '4',
      name: "Liam Jones",
      userName: "this.is.liam123",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1SiEfxr1q--HXdBy8q1ckx7IirlLt3R52',
      profilePictureShape: 'slanted',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '5',
      name: "Christian Thompson",
      userName: "chris_t71",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1sp3oMTRkRXPRMXZfaRq6cRt3oNrNvwCt',
      profilePictureShape: 'cookie6Sided',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '6',
      name: "Matthew Evans",
      userName: "evans_mat",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1QD_kj1U4vstuKn1wBCWtzbrtlMYsG-7y',
      profilePictureShape: 'clover4Leaf',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '7',
      name: "Chloe Johnson",
      userName: "j_chloe",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1C5XUQeqY8bvi2DE0KRi7zc_XIW3721C1',
      profilePictureShape: 'ghostish',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '8',
      name: "Archie White",
      userName: "archie_white7",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1KSuYNIP2S9luQxptHYzOoKa8URJozIe1',
      profilePictureShape: 'arch',
    ),
    bio: "Shaping spaces, one sketch at a time.",
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '9',
      name: "Sylvia Sunshine",
      userName: "sylvieshine9",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1HNDR8qiIArymcwzzThjXPblRf04nnSMn',
      profilePictureShape: 'pill',
    ),
    bio: "Your Friendly Celebrity Archon of Teyvat",
    pronouns: "she/her",
    followers: ['cook.with.shogun', 'director_hu54', 'princess_purple'],
    following: ['cook.with.shogun'],
    posts: [],
  ),
  Account(
    person: Person(
      id: '10',
      name: "Director  Hu",
      userName: "director_hu54",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1CQm-RSOfQxlKrXTOHlj_5JqhsqLsu8rq',
      profilePictureShape: 'ghostish',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '11',
      name: "David Young",
      userName: "its_davy_young",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1fuW9MzvqzgKl7Pt90v4eNUpMCRde1aGW',
      profilePictureShape: 'pill',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '12',
      name: "Joseph Martinez",
      userName: "m_jose_4",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1_ItVD4thjd2pjrthRRwL3zOcRYncTKJV',
      profilePictureShape: 'puffy',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '13',
      name: "Emily Davis",
      userName: "emyy_3_davy",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=11X_C6Kuddo4oN3NEBl9uyJ_rjEp0UDdN',
      profilePictureShape: 'puffy',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '14',
      name: "Sarah Jones",
      userName: "sarah.is.here3",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1ImyUUqXDNoOMAG-CQd6wAmCJpUS4F1nQ',
      profilePictureShape: 'clover8Leaf',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '15',
      name: "Olivia Brown",
      userName: "olivia_brow23",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1WkCovKGcGiTR1IbeJVIb8q4I7jZSdAxl',
      profilePictureShape: 'fan',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '16',
      name: "Sophia Rodriguez",
      userName: "your_sophie_here",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1BLZvqwu3Sah4NkisgGo1oMq-HSIpy2qV',
      profilePictureShape: 'cookie12Sided',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '17',
      name: "Eleanor Vance",
      userName: "iam_ellie_vance",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1FjyMwEPYPNPXkOBKMGRApIS9LHwHpGGe',
      profilePictureShape: 'cookie4Sided',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '18',
      name: "Emma Wilson",
      userName: "emma_wil71",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1FTdyeb7AQRE1GPxPCQNQPIw4lCN5p5r6',
      profilePictureShape: 'softBurst',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '19',
      name: "My cook book",
      userName: "cook.with.jane",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1nnB-bR3zVtWpgrDfSDEyFM0vi0iVss1S',
      profilePictureShape: 'bun',
    ),
    followers: ['director_hu54', 'princess_purple', 'furina_sunshine'],
    following: ['furina_sunshine'],
    posts: [],
  ),
  Account(
    person: Person(
      id: '20',
      name: "Madison White",
      userName: "maddie_white_79",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1-Kbjq30deI8v3Hb5SZo-7mUGkx-4Te1z',
      profilePictureShape: 'diamond',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '21',
      name: "Jenna Liebert",
      userName: "i.am.jenny.ig",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1SrM-csyz5iCWM3rzDGK_OVCJ83I1swN4',
      profilePictureShape: 'ghostish',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '22',
      name: "Sofia Garcia",
      userName: "sofia_garxcia",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1ECGhGr_tUXRlbPSOM0w8qa_OZ0krp9h7',
      profilePictureShape: 'clover8Leaf',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '23',
      name: "Venti",
      userName: "alkahol.iz.nat.fo.kidz",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1foQW29-ihziU6MMFYY7mc0VxLCYGkT81',
      profilePictureShape: 'boom',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '24',
      name: "Walt Z",
      userName: "eons_adrift",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1fuW9MzvqzgKl7Pt90v4eNUpMCRde1aGW',
      profilePictureShape: 'bun',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '25',
      name: "Xiao",
      userName: "conqurer_of_demons",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1u0z89yW1WxTUutqhQ-8DrcBlC1IAC5tI',
      profilePictureShape: 'gem',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '26',
      name: "Hannah Smith",
      userName: "hannah_smi_34",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=15hTDclZREA7NSTgiTEclmSEW3xZNz_YH',
      profilePictureShape: 'softBoom',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '27',
      name: "Helen Lightheart",
      userName: "is.this.helen.32",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1fTisKjCd5c_VEbSBgyIE0pissAajfVyk',
      profilePictureShape: 'ghostish',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
  Account(
    person: Person(
      id: '28',
      name: "Zhang Cheng",
      userName: "mr.zhang",
      profilePicturePath:
          'https://drive.google.com/uc?export=view&id=1JVAFXYHJXOTyRwoU9wtTlVOFm1w-I7_P',
      profilePictureShape: 'cookie4Sided',
    ),
    followers: [],
    following: [],
    posts: [],
  ),
];
Person getPersonFromUserName(String userName) {
  for (var element in accounts) {
    if (element.person.userName == userName) {
      return element.person;
    }
  }
  throw Exception("USER NOT FOUND : $userName");
}

Account getAccountFromUserName(String userName) {
  for (var element in accounts) {
    if (element.person.userName == userName) {
      return element;
    }
  }
  throw Exception("ACCOUNT NOT FOUND : $userName");
}

List<Story> myStories = [
  Story(
    duration: const Duration(seconds: 7),
    pathToMedia: '1w35ptuh4ixOJK6tJLbpwArG5xEQ6dS47',
    type: StoryType.image,
    uploadTime: '23 min',
  ),
  Story(
    duration: const Duration(seconds: 7),
    pathToMedia: '10wPKtmDBC8ylKcqWplQ3LOtreucDkxAN',
    type: StoryType.image,
    uploadTime: '23 min',
  ),
  Story(
    duration: const Duration(seconds: 7),
    pathToMedia: '1swN0I0kJVE-YogucSzCcObVkdQ-ORnh2',
    type: StoryType.image,
    uploadTime: '23 min',
  ),
  Story(
    duration: const Duration(seconds: 7),
    pathToMedia: '1JpcQdKOF3N2MJe00fSvvjSxAvhdbLAo4',
    type: StoryType.image,
    uploadTime: '23 min',
  ),
];

List<Note> notes = [
  Note(person: accounts[9].person, note: "Goodbye"),
  Note(person: accounts[10].person, note: "Finally completed my long work !"),
  Note(person: accounts[24].person, note: "blahhh!"),
  Note(person: accounts[16].person, note: "I'll be sleeping whole day today"),
  Note(person: accounts[19].person, note: "I am never cooking fried tofu again 😭"),
];

List<ChatText> chatTexts = [
  ChatText(textid: 0, text: "cyaa, byee", time: "8:26", repliedTo: 1, sentByUser: true),
  ChatText(textid: 1, text: "byee", time: "8:26"),
  ChatText(textid: 2, text: "Okayy than, see ya tomorrow", time: "8:25"),
  ChatText(
    textid: 3,
    text: "Alr, I will call them all",
    time: "8:25",
    repliedTo: 4,
    sentByUser: true,
  ),
  ChatText(
    textid: 4,
    text: "Ya, it's been a long time since we all went out together",
    time: "8:25",
    repliedTo: 5,
  ),
  ChatText(textid: 5, text: "Okay, should I call others too ??", time: "8:25", sentByUser: true),
  ChatText(textid: 6, text: "I am in 👍", time: "8:24", repliedTo: 8),
  ChatText(textid: 7, text: "A new park just opened last week", time: "8:24", sentByUser: true),
  ChatText(textid: 8, text: "So wanna go hangout morrow ?", time: "8:24", sentByUser: true),
  ChatText(
    textid: 9,
    text: "Had hard time getting into my room, its on second floor",
    time: "8:24",
  ),
  ChatText(textid: 10, text: "Heyy, don't remind me it", time: "8:23", repliedTo: 11),
  ChatText(
    textid: 11,
    text: "Hope you don't get scared while sleepin at night",
    time: "8:23",
    sentByUser: true,
  ),
  ChatText(textid: 12, text: "Just got shifted to the new house", time: "8:23"),
  ChatText(textid: 13, text: "hii", time: "8:23"),

  ChatText(textid: 14, text: "Done! Back online now.", time: "8:22"),
  ChatText(textid: 15, text: "Will do!", time: "8:21"),
  ChatText(
    textid: 16,
    text: "Cool, text me when you're fully settled in.",
    time: "8:20",
    sentByUser: true,
  ),
  ChatText(textid: 17, text: "Anyway, I need to go unlock the main gate.", time: "8:19"),
  ChatText(textid: 18, text: "Haha maybe a little bit 👻", time: "8:17", sentByUser: true),
  ChatText(
    textid: 19,
    text: "Oh shut up, you're just trying to scare me.",
    time: "8:16",
    repliedTo: 20,
  ),
  ChatText(
    textid: 20,
    text: "The one with the overgrown garden. People say it's haunted.",
    time: "8:15",
    sentByUser: true,
  ),
  ChatText(textid: 21, text: "Wait, what creepy house??", time: "8:13", repliedTo: 22),
  ChatText(
    textid: 22,
    text: "Except for that creepy old house down the street?",
    time: "8:12",
    sentByUser: true,
  ),
  ChatText(textid: 23, text: "Not yet, it looks pretty quiet though.", time: "8:11"),
  ChatText(
    textid: 24,
    text: "By the way, did you check out the neighborhood?",
    time: "8:10",
    sentByUser: true,
  ),
  ChatText(textid: 25, text: "Priorities indeed haha", time: "8:08", sentByUser: true),
  ChatText(
    textid: 26,
    text: "Priorities! 😂 Of course, that was first.",
    time: "8:07",
    repliedTo: 27,
  ),
  ChatText(textid: 27, text: "Sweet. Did you unpack the PC yet?", time: "8:06", sentByUser: true),
  ChatText(textid: 28, text: "Nah, the movers handled the heavy lifting.", time: "8:05"),
  ChatText(textid: 29, text: "Need any help carrying stuff?", time: "8:04", sentByUser: true),
  ChatText(textid: 30, text: "Yes! The truck just left.", time: "8:03"),
  ChatText(textid: 31, text: "Are you finally moving today?", time: "8:03", sentByUser: true),
  ChatText(textid: 32, text: "Yeah, just packing up some boxes. What's up?", time: "8:02"),
  ChatText(textid: 33, text: "Hey! You free to chat?", time: "8:01", sentByUser: true),
];

List<Reel> reels = [
  Reel(
    person: accounts[13].person,
    title: "Drawing still life",
    description: "",
    pathToMedia: "reels/v1.mp4",
    postId: 006,
    likes: 132,
    playCount: 4231,
  ),
];

const String linkToPfp =
    "https://drive.google.com/uc?export=view&id=1LB2B4h_hzLjZUb7AWAS8XNkrVa9JQ1yu";

const filterItems = <String>["Profiles", "Posts", "Reels", "Photos"];

const recentSearchs = <String>[
  "furina_sunshine",
  "kamisato.ayato",
  "cook.with.shogun",
  "princess_purple",
];

var searchAccounts = <Account>[
  accounts[3],
  accounts[6],
  accounts[19],
  accounts[15],
  accounts[23],
  accounts[16],
  accounts[7],
];

List<Person> suggestedPeople = [
  accounts[13].person,
  accounts[12].person,
  accounts[9].person,
  accounts[18].person,
  accounts[14].person,
  accounts[15].person,
  accounts[6].person,
];

List<Person> myFollowersConst = [
  accounts[3].person,
  accounts[4].person,
  accounts[5].person,
  accounts[6].person,
  accounts[7].person,
  accounts[12].person,
  accounts[15].person,
  accounts[19].person,
  accounts[24].person,
];
