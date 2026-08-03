import 'package:isar/isar.dart';
import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/data/mock_data.dart';

part 'comment.g.dart';

@collection
class Comment {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String commentId;

  @Index(composite: [CompositeIndex('parsedDateTime')])
  String postId;

  final String? replyToCommentId;
  final Person person;
  final String text;
  final String dateTime;

  @Index()
  late DateTime parsedDateTime;

  int likes;
  bool isLiked;

  Comment({
    required this.commentId,
    required this.person,
    required this.text,
    required this.dateTime,
    required this.postId,
    this.replyToCommentId,
    this.likes = 0,
    this.isLiked = false,
  }) {
    parsedDateTime = DateTime.tryParse(dateTime) ?? DateTime.now();
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['id'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      replyToCommentId: json['replyToCommentId'] as String?,
      person: getPersonFromUserId(json['userId']),
      text: json['text'] as String? ?? '',
      dateTime: json['dateTime'] as String? ?? DateTime.now().toIso8601String(),
      likes: json['likes'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }
}
