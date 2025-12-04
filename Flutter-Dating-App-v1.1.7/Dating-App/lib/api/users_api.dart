import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/api/blocked_users_api.dart';
import 'package:dating_app/constants/constants.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/plugins/geoflutterfire/geoflutterfire.dart';
import 'package:flutter/material.dart';

class UsersApi {
  /// Get firestore instance
  ///
  final _firestore = FirebaseFirestore.instance;

  /// Get all users
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getUsers({
    required List<DocumentSnapshot<Map<String, dynamic>>> dislikedUsers,
  }) async {
    /// Build Users query
    Query<Map<String, dynamic>> usersQuery = _firestore
        .collection(C_USERS)
        .where(USER_STATUS, isEqualTo: 'active')
        .where(USER_LEVEL, isEqualTo: 'user');

    // Filter the User Gender
    usersQuery = UserModel().filterUserGender(usersQuery);

    // Instance of Geoflutterfire
    final Geoflutterfire geo = Geoflutterfire();

    /// Get user settings
    final Map<String, dynamic>? settings = UserModel().user.userSettings;

    // // Get user geo center
    final GeoFirePoint center = geo.point(
        latitude: UserModel().user.userGeoPoint.latitude,
        longitude: UserModel().user.userGeoPoint.longitude);

    final allUsers = await geo
        .collection(collectionRef: usersQuery)
        .within(
            center: center,
            radius: settings![USER_MAX_DISTANCE].toDouble(),
            field: USER_GEO_POINT,
            strictMode: true)
        .first;

    // Remove the current user profile - If choosed to see everyone
    if (allUsers.isNotEmpty) {
      allUsers.removeWhere(
          (userDoc) => userDoc[USER_ID] == UserModel().user.userId);
    }

    /// Remove Disliked Users in list
    if (dislikedUsers.isNotEmpty) {
      for (var dislikedUser in dislikedUsers) {
        allUsers.removeWhere(
            (userDoc) => userDoc[USER_ID] == dislikedUser[DISLIKED_USER_ID]);
      }
    }

    // Get Liked Profiles
    final List<DocumentSnapshot<Map<String, dynamic>>> likedProfiles =
        (await _firestore
                .collection(C_LIKES)
                .where(LIKED_BY_USER_ID, isEqualTo: UserModel().user.userId)
                .get())
            .docs;

    // Remove Liked Profiles
    if (likedProfiles.isNotEmpty) {
      for (var likedUser in likedProfiles) {
        allUsers.removeWhere(
            (userDoc) => userDoc[USER_ID] == likedUser[LIKED_USER_ID]);
      }
    }

    // NEW feature - Remove Blocked Profiles from the list
    await BlockedUsersApi().removeBlockedUsers(allUsers).then((_) {
      debugPrint('removeBlockedUsers() -> success');
    }).catchError((e) {
      debugPrint('removeBlockedUsers() -> error: $e');
    });

    /// Sort by compatibility score (highest first), then by newest
    allUsers.sort((a, b) {
      // Calculate compatibility scores
      final int scoreA = UserModel().calculateCompatibilityScore(a[USER_KINKS]);
      final int scoreB = UserModel().calculateCompatibilityScore(b[USER_KINKS]);

      // Sort by compatibility first
      if (scoreA != scoreB) {
        return scoreB.compareTo(scoreA); // Higher score first
      }

      // If scores are equal, sort by newest
      final DateTime userRegDateA = a[USER_REG_DATE].toDate();
      final DateTime userRegDateB = b[USER_REG_DATE].toDate();
      return userRegDateB.compareTo(userRegDateA);
    });

    final int minAge = settings[USER_MIN_AGE];
    final int maxAge = settings[USER_MAX_AGE];
    final List<dynamic>? kinkFilters = settings[USER_FILTER_KINKS];

    // Filter Profile Ages and Kinks
    return allUsers.where((DocumentSnapshot<Map<String, dynamic>> user) {
      // Get User Birthday
      final DateTime userBirthday = DateTime(
          user[USER_BIRTH_YEAR], user[USER_BIRTH_MONTH], user[USER_BIRTH_DAY]);

      /// Get user profile age to filter
      final int profileAge = UserModel().calculateUserAge(userBirthday);

      // Age filter
      if (profileAge < minAge || profileAge > maxAge) {
        return false;
      }

      // Kink filter - if user has kink filters set, only show profiles with matching kinks
      if (kinkFilters != null && kinkFilters.isNotEmpty) {
        final List<dynamic>? userKinks = user[USER_KINKS];
        if (userKinks == null || userKinks.isEmpty) {
          return false; // Don't show users with no kinks if filtering
        }

        // Check if user has at least one matching kink
        final hasMatchingKink = kinkFilters.any((filter) => userKinks.contains(filter));
        if (!hasMatchingKink) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
