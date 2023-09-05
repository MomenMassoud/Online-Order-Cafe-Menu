import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _authenticating = false;

  bool get authenticating => _authenticating;

  late final FirebaseAuth _firebaseAuth;

  AuthenticationProvider(this._firebaseAuth);

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String dob,
    required String phoneNumber,
    required File image,
  }) async {
    _authenticating = true;
    notifyListeners();

    try {
      final userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredentials.user != null) {
        // Send verification email to user
        await userCredentials.user!.sendEmailVerification();

        String profilePicUrl = await uploadProfilePic(
            userCredentials.user!, image);

        FirebaseFirestore firestore = FirebaseFirestore.instance;
        String uid = userCredentials.user!.uid;
        int dt = DateTime
            .now()
            .millisecondsSinceEpoch;

        await firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'password': password,
          'uid': uid,
          'dt': dt,
          'dob': dob,
          'PhoneNumber': phoneNumber,
          'gender': gender,
          'profileImage': profilePicUrl,
          'emailVerified': false, // Mark email as not verified
        });

        _authenticating = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }

    _authenticating = false;
    notifyListeners();
    return false;
  }

  Future<bool> signIn({required String email, required String password}) async {
    _authenticating = true;
    notifyListeners();

    try {
      final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredentials.user != null) {
        bool userExists = await checkUserExists(userCredentials.user!.uid);
        if (userExists) {
          // Check if email is verified
          if (userCredentials.user!.emailVerified) {
            _authenticating = false;
            notifyListeners();
            return true;
          } else {
            // Sign user out and display error message
            await _firebaseAuth.signOut();
            // Display error message or redirect user to email verification screen
          }
        } else {
          // User account has been deleted from Firebase, prompt user to sign up again
          _authenticating = false;
          notifyListeners();
          // Display sign up screen or error message
        }
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }

    _authenticating = false;
    notifyListeners();
    return false;
  }

  Future<bool> checkUserExists(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userSnapshot.exists;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String> uploadProfilePic(User user, File imageFile) async {
    var fileName = '${user.email!}.jpg';

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(fileName)
        .putFile(imageFile);

    TaskSnapshot snapshot = await uploadTask;

    String profileImageUrl = await snapshot.ref.getDownloadURL();
    return profileImageUrl;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}