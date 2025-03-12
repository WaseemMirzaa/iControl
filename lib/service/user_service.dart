import 'package:firebase_database/firebase_database.dart';
import 'package:app_name/model/user_model.dart';
import 'package:app_name/views/core/core/utils/constants/app_const.dart';

class UserService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Check if email exists in Realtime Database
  Future<bool> isEmailExists(String email) async {
    try {
      final snapshot = await _dbRef
          .child(AppConst.usersCollection)
          .orderByChild(AppConst.emailField)
          .equalTo(email.trim())
          .limitToFirst(1)
          .get();

      return snapshot.exists;
    } catch (e) {
      throw Exception('Failed to check email existence: $e');
    }
  }

  // Create a new user in Realtime Database
  Future<void> createUser(String uid, UserModel user) async {
    try {
      final userData = user.toJson()..remove(AppConst.passwordField);
      await _dbRef.child(AppConst.usersCollection).child(uid).set(userData);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Update user's last login time
  Future<void> updateUserLoginTime(String uid) async {
    try {
      await _dbRef.child(AppConst.usersCollection).child(uid).update({
        AppConst.lastLoginAtField: DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update login time: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final snapshot =
          await _dbRef.child(AppConst.usersCollection).child(uid).get();

      if (snapshot.exists) {
        return UserModel.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Check if user is verified
  Future<bool> isUserVerified(String uid) async {
    try {
      final snapshot = await _dbRef
          .child(AppConst.usersCollection)
          .child(uid)
          .child(AppConst.isVerifiedField)
          .get();

      return snapshot.exists && snapshot.value == true;
    } catch (e) {
      throw Exception('Failed to check verification status: $e');
    }
  }

  // Update user's verification status
  Future<void> updateUserVerificationStatus(String uid, bool isVerified) async {
    try {
      // Reference to the user's verification field in the database
      final userRef = _dbRef.child(AppConst.usersCollection).child(uid);

      await userRef.update({
        AppConst.isVerifiedField: isVerified,
      });

      // Optionally, you can log the successful update or provide feedback
      print('User verification status updated for UID: $uid');
    } catch (e) {
      // Handle any errors that occur during the update
      print('Error updating verification status for UID: $uid, Error: $e');
      throw Exception('Failed to update verification status for user: $uid');
    }
  }

  Future<void> addPermissions(
      String email, Map<String, dynamic> permissions) async {
    try {
      final sanitizedEmail = email.replaceAll('.', '_');
      final permissionsRef = _dbRef.child('permissions').child(sanitizedEmail);
      await permissionsRef.set(permissions);
      ('Permissions added successfully for $sanitizedEmail');
    } catch (e) {
      ('Error adding permissions for $email: $e');
      throw Exception('Failed to add permissions: $e');
    }
  }
}
