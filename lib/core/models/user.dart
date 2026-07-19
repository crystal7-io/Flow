import 'package:isar/isar.dart';
part 'user.g.dart';

@collection
class User {
  Id isarID = 1;

  final String id;
  String userName;
  String name;
  String profilePicturePath;

  String? bio;
  bool isProfilePrivate;
  String? pronouns;
  List<String> followerIDs;
  List<String> followingIDs;
  List<String> postIDs;
  List<String> likedPostIDs;
  List<String> commentIDs;

  User({
    required this.id,
    required this.userName,
    required this.name,
    required this.profilePicturePath,
    this.bio,
    this.isProfilePrivate = false,
    this.pronouns,
    this.followerIDs = const [],
    this.followingIDs = const [],
    this.postIDs = const [],
    this.likedPostIDs = const [],
    this.commentIDs = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      profilePicturePath: json['profilePicturePath'] as String,
      bio: json['bio'] as String?,
      isProfilePrivate: json['isProfilePrivate'] as bool? ?? false,
      pronouns: json['pronouns'] as String?,
      followerIDs: List<String>.from(json['followerIDs'] ?? []),
      followingIDs: List<String>.from(json['followingIDs'] ?? []),
      postIDs: List<String>.from(json['postIDs'] ?? []),
      likedPostIDs: List<String>.from(json['likedPostIDs'] ?? []),
      commentIDs: List<String>.from(json['commentIDs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'profilePicturePath': profilePicturePath,
      'bio': bio,
      'isProfilePrivate': isProfilePrivate,
      'pronouns': pronouns,
      'followerIDs': followerIDs,
      'followingIDs': followingIDs,
      'postIDs': postIDs,
      'likedPostIDs': likedPostIDs,
      'commentIDs': commentIDs,
    };
  }
}
