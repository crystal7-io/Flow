import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redesigned/core/constants/json_file_paths.dart';

import 'package:redesigned/core/models/comment.dart';
import 'package:redesigned/core/models/like/comment_like.dart';
import 'package:redesigned/core/models/like/post_like.dart';
import 'package:redesigned/core/models/user.dart';

/// Service responsible for managing local Isar database lifecycle operations,
/// including schema initialization and initial dataset seeding.
class IsarService {
  /// Initializes the Isar database instance and executes one-time initial seeding.
  ///
  /// Opens tables for [UserSchema], [PostLikeSchema], and [CommentSchema].
  /// This should be invoked prior to [runApp] in the application lifecycle.
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    final isar = await Isar.open([
      UserSchema,
      PostLikeSchema,
      CommentSchema,
      CommentLikeSchema,
    ], directory: dir.path);

    await _seedDatabaseIfNeeded(isar);
  }

  /// Populates the database with default asset JSON data on first app execution.
  ///
  /// Checks table count prior to execution to prevent duplicate seeding across
  /// subsequent application launches.
  static Future<void> _seedDatabaseIfNeeded(Isar isar) async {
    final count = await isar.comments.count();
    if (count > 0) return;

    final results = await Future.wait([rootBundle.loadString(JsonFilePaths.commentsJson)]);

    final commentsJson = json.decode(results[0]) as List<dynamic>;

    final commentsToInsert = commentsJson
        .map((item) => Comment.fromJson(item as Map<String, dynamic>))
        .toList();

    await isar.writeTxn(() async {
      await isar.comments.putAll(commentsToInsert);

      // Other seeds to be updated-----
    });
  }
}
