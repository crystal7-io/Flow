import 'package:redesigned/core/models/person.dart';
import 'package:redesigned/core/models/post.dart';

class Account {
  Account({
    required this.person,
    this.bio = "",
    this.isPrivate = true,
    this.pronouns = '',
    this.followers = const [],
    this.following = const [],
    this.posts = const [],
  });

  final Person person;
  final List<Post> posts;

  bool isPrivate;
  String bio;
  String pronouns;
  List<String> followers;
  List<String> following;
}
