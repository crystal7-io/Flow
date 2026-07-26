import 'package:isar/isar.dart';
import 'package:redesigned/core/models/user.dart';

class LocalUserDataSource {
  Isar get _isar => Isar.getInstance()!;

  /// Retrieves a [User] object from the local database
  Future<User?> getUserData() async {
    return _isar.users.get(0);
  }

  /// Saves user data to local database
  Future<void> saveUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  /// Initializes default user if not exists
  Future<void> initializeDefaultUser() async {
    final existingUser = await _isar.users.get(0);
    if (existingUser == null) {
      final defaultUser = User(
        id: 'test_user',
        userName: 'crystalarc7',
        name: 'Crystal',
        profilePicturePath:
            'https://drive.google.com/uc?export=view&id=1LB2B4h_hzLjZUb7AWAS8XNkrVa9JQ1yu',
        bio: 'Just another tech enthusiast. Exploring the world of Flutter.',
        pronouns: 'she/her',
      );
      await saveUser(defaultUser);
    }
  }
}
