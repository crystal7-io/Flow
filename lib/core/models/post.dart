import 'package:redesigned/core/models/person.dart';

enum PostType { carosel, image, reel }

class Post {
  final Person person;
  final PostType type;
  final DateTime dateTime;
  final String postId;
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

  Post copyWith({
    Person? person,
    PostType? type,
    DateTime? dateTime,
    String? postId,
    String? coverImagePath,
    double? aspectRatio,
    String? subTitle,
    int? likes,
    bool? isLiked,
    bool? saved,
    List? comments,
    List<String>? tags,
  }) {
    return Post(
      person: person ?? this.person,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      postId: postId ?? this.postId,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      subTitle: subTitle ?? this.subTitle,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      saved: saved ?? this.saved,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
    );
  }
}

class CarouselPostObject extends Post {
  List<String> imagePaths;

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

  @override
  CarouselPostObject copyWith({
    Person? person,
    PostType? type,
    DateTime? dateTime,
    String? postId,
    String? coverImagePath,
    double? aspectRatio,
    String? subTitle,
    List<String>? imagePaths,
    int? likes,
    bool? isLiked,
    bool? saved,
    List? comments,
    List<String>? tags,
  }) {
    return CarouselPostObject(
      person: person ?? this.person,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      postId: postId ?? this.postId,
      subTitle: subTitle ?? this.subTitle,
      imagePaths: imagePaths ?? this.imagePaths,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      saved: saved ?? this.saved,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
    );
  }
}

class ImagePostObject extends Post {
  String imagePath;

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

  @override
  ImagePostObject copyWith({
    Person? person,
    PostType? type,
    DateTime? dateTime,
    String? postId,
    String? coverImagePath,
    double? aspectRatio,
    String? subTitle,
    String? imagePath,
    int? likes,
    bool? isLiked,
    bool? saved,
    List? comments,
    List<String>? tags,
  }) {
    return ImagePostObject(
      person: person ?? this.person,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      postId: postId ?? this.postId,
      subTitle: subTitle ?? this.subTitle,
      imagePath: imagePath ?? this.imagePath,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      saved: saved ?? this.saved,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
    );
  }
}

class VideoPostObject extends Post {
  String sourcePath;

  VideoPostObject({
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

  @override
  VideoPostObject copyWith({
    Person? person,
    PostType? type,
    DateTime? dateTime,
    String? postId,
    String? coverImagePath,
    double? aspectRatio,
    String? subTitle,
    String? sourcePath,
    int? likes,
    bool? isLiked,
    bool? saved,
    List? comments,
    List<String>? tags,
  }) {
    return VideoPostObject(
      person: person ?? this.person,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      postId: postId ?? this.postId,
      subTitle: subTitle ?? this.subTitle,
      sourcePath: sourcePath ?? this.sourcePath,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      saved: saved ?? this.saved,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
    );
  }
}
