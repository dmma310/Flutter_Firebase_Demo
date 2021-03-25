import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wastegram_extended/models/post.dart';
import 'package:wastegram_extended/models/user.dart';
import 'package:wastegram_extended/services/auth_provider.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference _wastedItemsCollectionReference =
      FirebaseFirestore.instance.collection('wasted_items');

  // Create and add user to collection
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  CollectionReference get postsCollection => _wastedItemsCollectionReference;

  // Create and add post to Firestore collection
  Future<void> createPost({Post post}) async {
    try {
      await _wastedItemsCollectionReference.add(post.toJson());
    } catch (e) {
      print(e);
    }
  }

// TODO: Update post data

// Delete post data
  Future<void> deletePost({String id}) async {
    try {
      await _wastedItemsCollectionReference.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  // Get current user id
  Future<String> currentFirestoreUserProperty({@required BuildContext context, @required String property}) async {
    // Get current user ID from Firebase Auth
    String currUserID = AuthProvider.of(context).auth.currentFirebaseAuthUserID();

    // Get and return corresponding user from Firestore users collection, which is the same name as the document ID
    // Assumes ID is same name as document name in users collection. If not, need to loop and find.
    final DocumentSnapshot user = await _usersCollectionReference.doc(currUserID).get();
    return
     user.data()[property];
  }
}
