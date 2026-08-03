import 'package:isar/isar.dart';
part 'comment_like.g.dart';

/// A simple class for isar collection to store comments likes locally
@collection
class CommentLike {
  CommentLike({required this.userId, required this.createdAt, required this.commentId});
  Id id = Isar.autoIncrement;

  // Composite index ensures fast lookups & prevents duplicate likes
  @Index(composite: [CompositeIndex('commentId')], unique: true)
  final String userId;

  final String commentId;

  final DateTime createdAt;
}
