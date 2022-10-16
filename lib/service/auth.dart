import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String mail, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: mail, password: password);
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  signInAnonymous() async{
    var user = await _auth.signInAnonymously();
    return user.user;
  }

  Future<User?> register(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await _firestore.collection("Person").doc(user.user?.uid).set({'userName': name,'email': email, 'pictureLink': ""});

    return user.user;
  }

  Future updateUserName(String userName, String userUid) async{
    return await _firestore.collection("Person").doc(userUid).update({'userName' : userName});
  }
}