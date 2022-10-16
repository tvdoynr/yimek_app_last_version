import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PictureService{
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future getPhotoFromCam() async{
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    var file = File(image!.path);

    Reference reference = FirebaseStorage.instance.ref().child("profile_pictures").child(
          _auth.currentUser!.uid).child("profile_picture.png");

    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot= await task;

    String url = await snapshot.ref.getDownloadURL();

    FirebaseFirestore.instance.collection('Person').doc(_auth.currentUser!.uid).update({"pictureLink": url});

    return url;
  }

  Future getPhotoFromGallery() async{
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    Reference reference = FirebaseStorage.instance.ref().child("profile_pictures").child(
        _auth.currentUser!.uid).child("profile_picture.png");

    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot= await task;

    String url = await snapshot.ref.getDownloadURL();

    FirebaseFirestore.instance.collection('Person').doc(_auth.currentUser!.uid).update({"pictureLink": url});
    return url;
  }

}