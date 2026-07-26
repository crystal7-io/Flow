import 'package:isar/isar.dart';
part 'post_like.g.dart';

/// A simple class for isar collection to store post likes locally
@collection
class PostLike {
  PostLike({required this.userId, required this.createdAt, required this.postId});
  Id id = Isar.autoIncrement;

  // Composite index ensures fast lookups & prevents duplicate likes
  @Index(composite: [CompositeIndex('postId')], unique: true)
  final String userId;

  final String postId;

  final DateTime createdAt;
}
