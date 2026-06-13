import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:redesigned/core/constants/file_paths.dart';
import 'package:redesigned/core/models/profile.dart';

abstract class IProfileRepository {
  /// Person data
  Profile? get profile;

  /// Follow /Unfollow profile
  Future<void> toggleFollow();

  /// Refresh Profile Data
  Future<void> getProfileData();
}

class ProfileRepository implements IProfileRepository {
  String? _userID;

  ProfileRepository(String userID) {
    _userID = userID;
  }

  Profile? _profile;

  @override
  Profile? get profile => _profile;

  /// Get profile Data, private as its initiated at creation of objecet
  /// After this, user Refresh Profile to refresh data
  @override
  Future<void> getProfileData() async {
    try {
      // get jsonString of all Users
      String jsonString = await rootBundle.loadString(usersJson);
      if (kDebugMode) {
        print(_userID);
        print(jsonString);
      }
      // Convert string to Map
      Map<String, dynamic> dataObj = jsonDecode(jsonString);
      String dummy = '''{
    "id": "a1b2c3d4-e5f6-4789-90ab-cdef01234567",
    "userName": "EthanB_7",
    "name": "Ethan Brown",
    "profilePicturePath": "https://drive.google.com/uc?export=view&id=1t8ON-QsNgAC1ry7OHNzBbG1uLiLIjES2",
    "bio": "Fitness first, always.",
    "isProfilePrivate": true,
    "pronouns": null,
    "followerIDs": [
      "k1l2m3n4-o5p6-4789-4567-890123456789",
      "c9d0e1f2-a3b4-4567-2345-678901234567",
      "b2c3d4e5-f6a7-4890-bcde-f01234567890",
      "h8i9j0k1-l2m3-4456-1234-567890123456",
      "n4o5p6q7-r8s9-4012-7890-123456789012",
      "l2m3n4o5-p6q7-4890-5678-901234567890",
      "z6a7b8c9-d0e1-4234-9012-345678901234",
      "s9t0u1v2-w3x4-4567-2345-678901234567",
      "t0u1v2w3-x4y5-4678-3456-789012345678",
      "f6a7b8c9-d0e1-4234-f012-345678901234",
      "b8c9d0e1-f2a3-4456-1234-567890123456",
      "i9j0k1l2-m3n4-4567-2345-678901234567",
      "j0k1l2m3-n4o5-4678-3456-789012345678",
      "p6q7r8s9-t0u1-4234-9012-345678901234",
      "r8s9t0u1-v2w3-4456-1234-567890123456",
      "e5f6a7b8-c9d0-4123-ef01-234567890123",
      "o5p6q7r8-s9t0-4123-8901-234567890123",
      "v2w3x4y5-z6a7-4890-5678-901234567890",
      "a7b8c9d0-e1f2-4345-0123-456789012345"
    ],
    "followingIDs": [
      "c3d4e5f6-a7b8-4901-cdef-012345678901",
      "x4y5z6a7-b8c9-4012-7890-123456789012",
      "j0k1l2m3-n4o5-4678-3456-789012345678",
      "h8i9j0k1-l2m3-4456-1234-567890123456",
      "z6a7b8c9-d0e1-4234-9012-345678901234",
      "f6a7b8c9-d0e1-4234-f012-345678901234",
      "s9t0u1v2-w3x4-4567-2345-678901234567",
      "b2c3d4e5-f6a7-4890-bcde-f01234567890",
      "e5f6a7b8-c9d0-4123-ef01-234567890123",
      "v2w3x4y5-z6a7-4890-5678-901234567890",
      "c9d0e1f2-a3b4-4567-2345-678901234567",
      "q7r8s9t0-u1v2-4345-0123-456789012345",
      "d4e5f6a7-b8c9-4012-def0-123456789012",
      "k1l2m3n4-o5p6-4789-4567-890123456789",
      "l2m3n4o5-p6q7-4890-5678-901234567890",
      "m3n4o5p6-q7r8-4901-6789-012345678901",
      "p6q7r8s9-t0u1-4234-9012-345678901234"
    ],
    "postIDs": [],
    "likedPostIDs": [],
    "commentIDs": [],
    "email": "ethan.brown@example.com",
    "phoneNumber": "+1-555-0101",
    "gender": "male",
    "dateJoined": "2020-01-15T10:00:00Z",
    "lastOnline": "2024-06-20T14:30:00Z"
  }''';

      // Get data of user by ID as key from map
      _profile = Profile.fromJson(
        dataObj[_userID] ?? jsonDecode(dummy) as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> toggleFollow() async {
    /// TODO: Implement toggleFollow
  }
}
