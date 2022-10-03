import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yimek_app_lastversion/models/Food.dart';

class FoodService{
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  addFood(String foodName, String userName, String userID, String comment) async{
    var collection = firebaseFirestore.collection(foodName);

    var documentRef = await collection.add({
      'comment': comment,
      'userId': userID,
      'userName' : userName,
      'time' : Timestamp.now()
    });

    return Food(id: documentRef.id, comment: comment, userId: userID, userName: userName);
  }

  Stream<QuerySnapshot> getComments(String foodName) {
    var collection = firebaseFirestore.collection(foodName).orderBy("time", descending: true).snapshots();

    return collection;
  }

}