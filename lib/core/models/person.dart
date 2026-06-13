class Person {
  String id;
  String userName;
  String name;
  String profilePicturePath;
  final bool isStoryVisible;
  final bool newStory;

  Person({
    required this.id,
    required this.userName,
    required this.name,
    required this.profilePicturePath,
    this.isStoryVisible = false,
    this.newStory = false,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePicturePath:
          json['profilePicturePath'] as String? ??
          json['pfpPath'] as String? ??
          '',
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
      'isStoryVisible': isStoryVisible,
      'newStory': newStory,
    };
  }

  /// Alias for profilePicturePath used in some old components
  String get pfpPath => profilePicturePath;
}

class FollowPerson extends Person {
  FollowPerson({
    required super.id,
    required super.name,
    required super.userName,
    required super.profilePicturePath,
    required this.isFollowing,
    super.isStoryVisible,
    super.newStory,
  });
  bool isFollowing;
}
