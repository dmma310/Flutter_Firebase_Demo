import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastegram_extended/services/analytics_service.dart';
import 'package:wastegram_extended/services/firestore_service.dart';
import 'package:wastegram_extended/models/user.dart' as MyUser;

 // Source: https://www.filledstacks.com/post/firebase-analytics-and-metrics-in-flutter/
class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirestoreService _firestoreService = FirestoreService();
  static final AnalyticsService _analytics = AnalyticsService();

  // Subscribe and get authentication state of user, return user if logged in.
  Stream<User> get authStateChanges {
    return FirebaseAuth.instance.authStateChanges();
  }

  // TODO: Error handling not working if user does not exist
  Future<void> signInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _analytics.logLogin();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUpWithEmail({
    @required String password,
    @required String email,
    @required String role,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Create user in Firestore users collection with newly created id, and return id
      await _firestoreService.createUser(
          MyUser.User(id: authResult.user.uid, email: email, userRole: role));
      // set the user id on the analytics service
      await _analytics.setUserProperties(userID: currentFirebaseAuthUserID(), userRole: currentUserRole());
      await _analytics.logSignUp();
    } catch (e) {
      return e.message;
    }
  }

  String currentFirebaseAuthUserID() {
    // Return current user ID from Firebase Auth (NOT from Firestore users collection)
    final User user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  String currentUserRole() {
    final User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  Future<void> signOut() async {
    try {
      return _firebaseAuth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
