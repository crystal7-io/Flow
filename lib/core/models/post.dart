import 'package:redesigned/core/models/person.dart';

enum PostType { carosel, image, reel }

class Post {
  final Person person;
  final PostType type;
  final DateTime dateTime;
  final int postId;
  final String coverImagePath;
  final double aspectRatio;
  String subTitle;
  int likes;
  bool isLiked;
  bool saved;
  List comments;
  List<String> tags;
  Post({
    required this.person,
    required this.type,
    required this.dateTime,
    required this.postId,
    required this.aspectRatio,
    required this.subTitle,
    required this.coverImagePath,
    this.likes = 0,
    this.isLiked = false,
    this.saved = false,
    this.comments = const [],
    this.tags = const [],
  });
}

class CarouselPostObject extends Post {
  CarouselPostObject({
    required super.person,
    required super.type,
    required super.dateTime,
    required super.postId,
    required super.subTitle,
    required this.imagePaths,
    super.likes = 0,
    super.isLiked = false,
    super.saved = false,
    super.comments = const [],
    required super.aspectRatio,
    super.tags,
  }) : super(coverImagePath: imagePaths[0]);
  List<String> imagePaths;
}

class ImagePostObject extends Post {
  ImagePostObject({
    required super.person,
    required super.type,
    required super.dateTime,
    required super.postId,
    required super.subTitle,
    required this.imagePath,
    super.likes = 0,
    super.isLiked = false,
    super.saved = false,
    required super.aspectRatio,
    super.comments = const [],
    super.tags,
  }) : super(coverImagePath: imagePath);
  String imagePath;
}

class ReelPostObject extends Post {
  ReelPostObject({
    required super.person,
    required super.type,
    required super.dateTime,
    required super.postId,
    required super.subTitle,
    required this.sourcePath,
    super.likes = 0,
    super.isLiked = false,
    super.saved = false,
    required super.aspectRatio,
    super.comments = const [],
    super.tags,
  }) : super(coverImagePath: sourcePath);
  String sourcePath;
}
