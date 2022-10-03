import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Food{
  String id;
  String comment;
  String userId;
  String userName;

  Food({required this.id,required this.comment,required this.userId,required this.userName});

  factory Food.fromSnaphot(DocumentSnapshot documentSnapshot){
    return Food(id: documentSnapshot.id,comment: documentSnapshot["comment"], userId: documentSnapshot["userId"], userName: documentSnapshot["userName"]);
  }
}