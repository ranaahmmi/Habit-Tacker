import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prefecthabittracer/models/user.dart';
import 'package:prefecthabittracer/ui/login_page.dart';

import 'Database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid, email: user.email);
  }

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future login({@required email, @required password}) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      _userFromFirebase(user);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future singup({@required email, @required password}) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;

      await DatabaseService(uid: user.uid)
          .updateUserData(name, 'Hello I\'m new on the Habbit Tracker App');
      _userFromFirebase(user);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
