import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:penny_pal/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to listen to auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Sign up with Email & Password
  Future<UserModel?> signUp({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        // Create the user document in Firestore
        UserModel newUser = UserModel(
          userId: user.uid,
          fullName: fullName,
          email: email,
          mobileNumber: mobileNumber,
          role: 'student',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          hasSeenTutorial: false,
        );

        await _db.collection('Users').doc(user.uid).set(newUser.toMap());
        
        // Create initial default profile
        UserProfile newProfile = UserProfile(
          profileId: user.uid, // Using uid as profileId for 1-to-1 mapping
          userId: user.uid,
          studentStatus: 'Active',
          currencyPreference: 'USD',
          notificationPreference: 'All',
        );
        
        await _db.collection('UserProfiles').doc(user.uid).set(newProfile.toMap());

        return newUser;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Log in with Email & Password
  Future<UserModel?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        // Update last login
        await _db.collection('Users').doc(user.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        // Fetch user data
        DocumentSnapshot doc = await _db.collection('Users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Log out
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // Get User Data
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('Users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
    return null;
  }
}
