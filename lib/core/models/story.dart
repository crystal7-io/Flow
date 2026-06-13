import 'package:redesigned/core/models/person.dart';

enum StoryType { image, reel }

class Story {
  Story({
    required this.duration,
    required this.pathToMedia,
    required this.type,
    required this.uploadTime,
    this.isLiked = false,
    this.isViewd = false,
  });
  Duration duration;
  bool isLiked;
  bool isViewd;
  String pathToMedia;
  StoryType type;
  String uploadTime;
}

class StoryGroup {
  Person person;
  List<Story> stories;
  StoryGroup({required this.person, required this.stories});
}
