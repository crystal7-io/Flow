import 'package:isar/isar.dart';
part 'person.g.dart';

@embedded
class Person {
  String id;
  String userName;
  String name;
  String profilePicturePath;
  String profilePictureShape;
  bool isStoryVisible;
  bool newStory;

  Person({
    this.id = '',
    this.userName = '',
    this.name = '',
    this.profilePicturePath = '',
    this.profilePictureShape = 'circle',
    this.isStoryVisible = false,
    this.newStory = false,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicturePath: json['profilePicturePath'] as String? ?? json['pfpPath'] as String? ?? '',
      profilePictureShape: json['profilePictureShape'] as String? ?? 'circle',
      isStoryVisible: json['isStoryVisible'] as bool? ?? false,
      newStory: json['newStory'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'profilePicturePath': profilePicturePath,
      'profilePictureShape': profilePictureShape,
      'isStoryVisible': isStoryVisible,
      'newStory': newStory,
    };
  }

  @ignore
  String get pfpPath => profilePicturePath;
}

class FollowPerson extends Person {
  FollowPerson({
    super.id = '',
    super.name = '',
    super.userName = '',
    super.profilePicturePath = '',
    super.profilePictureShape = 'circle',
    required this.isFollowing,
    super.isStoryVisible,
    super.newStory,
  });
  bool isFollowing;
}
