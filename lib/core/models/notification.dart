import 'package:redesigned/core/models/person.dart';

enum NotifType { commentLike, commentReply, postLike, postComment, storyLike, follow }

abstract class Notif {
  final NotifType notifType;
  final Person notifier;
  final String time;
  final String textContent;
  final String contextImagePath;
  const Notif({
    required this.notifType,
    required this.notifier,
    required this.time,
    required this.textContent,
    required this.contextImagePath,
  });
}

class CommentReplyNotficaiton extends Notif {
  CommentReplyNotficaiton({
    required super.notifier,
    required super.time,
    required this.reply,
    required this.postID,
    required this.commentText,
    required this.isLiked,
    required super.contextImagePath,
  }) : super(notifType: NotifType.commentReply, textContent: "Replied to your comment");
  final String commentText;
  final String reply;
  final bool isLiked;
  final int postID;
}

class CommentLikeNotficaiton extends Notif {
  CommentLikeNotficaiton({
    required super.notifier,
    required super.time,
    required this.postID,
    required this.commentText,
    required super.contextImagePath,
  }) : super(notifType: NotifType.commentLike, textContent: "liked your comment");
  String text = "";
  final String commentText;
  final int postID;
}

class PostCommentNotficaiton extends Notif {
  PostCommentNotficaiton({
    required super.notifier,
    required super.time,
    required this.reply,
    required this.postID,
    required this.isLiked,
    required super.contextImagePath,
  }) : super(notifType: NotifType.commentReply, textContent: "commented on your post");
  String text = "";
  final String reply;
  final bool isLiked;
  final int postID;
}

class PostLikeNotification extends Notif {
  PostLikeNotification({
    required super.notifier,
    required super.time,
    required this.postID,
    required super.contextImagePath,
  }) : super(notifType: NotifType.postLike, textContent: "Liked your Post");
  final int postID;
}

class FollowNotification extends Notif {
  FollowNotification({
    required super.notifier,
    required super.time,
    required super.contextImagePath,
  }) : super(notifType: NotifType.follow, textContent: "Started following you");
}

class StoryLikeNotification extends Notif {
  final int storyNum;
  StoryLikeNotification({
    required super.notifier,
    required super.time,
    required this.storyNum,
    required super.contextImagePath,
  }) : super(notifType: NotifType.postLike, textContent: "Liked your story");
}
