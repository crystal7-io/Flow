import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redesigned/core/models/user.dart';

class LocalUserDataSource {
  static Isar? _isar;

  Future<Isar> _getInstance() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([UserSchema], directory: dir.path);
    return _isar!;
  }

  /// Retrieves a [User] object from the local database
  Future<User?> getUserData() async {
    final isar = await _getInstance();
    return isar.users.get(0);
  }

  /// Saves user data to local database
  Future<void> saveUser(User user) async {
    final isar = await _getInstance();
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  /// Initializes default user if not exists
  Future<void> initializeDefaultUser() async {
    final isar = await _getInstance();
    final existingUser = await isar.users.get(0);
    if (existingUser == null) {
      final defaultUser = User(
        id: 'crystalarc7_id',
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
