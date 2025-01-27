import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:app_name/views/core/core/utils/constants/app_const.dart';

class UserModel {
  String? email;
  String? password;
  bool? isVerified;
  String? uid;
  String? displayName;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? lastLoginAt;
  Map<String, dynamic>? metadata;

  // Default constructor with all optional fields
  UserModel({
    this.email,
    this.password,
    this.isVerified,
    this.uid,
    this.displayName,
    this.photoUrl,
    this.createdAt,
    this.lastLoginAt,
    this.metadata,
  });

  // Factory constructor to create UserModel from a Realtime Database snapshot
  factory UserModel.fromDataSnapshot(DataSnapshot snapshot) {
    DateTime? _parseDate(dynamic dateField) {
      if (dateField is String) {
        try {
          return DateTime.parse(dateField); // Parse string to DateTime
        } catch (e) {
          return null; // Handle invalid date strings
        }
      }
      return null;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return UserModel(
      email: data[AppConst.emailField] as String?,
      isVerified: data[AppConst.isVerifiedField] as bool?,
      uid: snapshot.key, // Use the key as UID
      displayName: data[AppConst.displayNameField] as String?,
      photoUrl: data[AppConst.photoUrlField] as String?,
      createdAt: _parseDate(data[AppConst.createdAtField]),
      lastLoginAt: _parseDate(data[AppConst.lastLoginAtField]),
      metadata: data[AppConst.metadataField] as Map<String, dynamic>?,
    );
  }

  // Factory constructor to create UserModel from FirebaseAuth User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      email: user.email,
      isVerified: user.emailVerified,
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      metadata: {
        'lastSignInTime': user.metadata.lastSignInTime?.toIso8601String(),
        'creationTime': user.metadata.creationTime?.toIso8601String(),
      },
    );
  }

  // Factory constructor to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json[AppConst.emailField] as String?,
      password: json[AppConst.passwordField] as String?,
      isVerified: json[AppConst.isVerifiedField] as bool?,
      uid: json[AppConst.uidField] as String?,
      displayName: json[AppConst.displayNameField] as String?,
      photoUrl: json[AppConst.photoUrlField] as String?,
      createdAt: json[AppConst.createdAtField] != null
          ? DateTime.parse(json[AppConst.createdAtField] as String)
          : null,
      lastLoginAt: json[AppConst.lastLoginAtField] != null
          ? DateTime.parse(json[AppConst.lastLoginAtField] as String)
          : null,
      metadata: json[AppConst.metadataField] as Map<String, dynamic>?,
    );
  }

  // Convert UserModel to JSON for Realtime Database
  Map<String, dynamic> toJson() {
    return {
      AppConst.emailField: email,
      AppConst.passwordField: password,
      AppConst.isVerifiedField: isVerified,
      AppConst.uidField: uid,
      AppConst.displayNameField: displayName,
      AppConst.photoUrlField: photoUrl,
      AppConst.createdAtField: createdAt?.toIso8601String(),
      AppConst.lastLoginAtField: lastLoginAt?.toIso8601String(),
      AppConst.metadataField: metadata,
    };
  }

  // Copy with method for immutable updates
  UserModel copyWith({
    String? email,
    String? password,
    bool? isVerified,
    String? uid,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'UserModel(email: $email, isVerified: $isVerified, uid: $uid, '
        'displayName: $displayName, createdAt: $createdAt)';
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.email == email &&
        other.uid == uid &&
        other.isVerified == isVerified &&
        other.displayName == displayName &&
        other.photoUrl == photoUrl;
  }

  // Override hashCode
  @override
  int get hashCode {
    return Object.hash(
      email,
      uid,
      isVerified,
      displayName,
      photoUrl,
    );
  }

  // Check if user is empty/guest
  bool get isEmpty => email == null && uid == null;
  bool get isNotEmpty => !isEmpty;

  // Check if user has complete profile
  bool get hasCompleteProfile =>
      email != null && isVerified == true && displayName != null;
}
