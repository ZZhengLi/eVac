import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

Future<void> checkAuth() async {
  try {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Signed In Already");
    } else {
      print("Signed Out");
    }
  } catch (e) {
    print(e);
  }
}

Future<void> signUp(String email, String password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    print(e);
  }
}

Future signIn(String email, String password) async {
  try {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    return e;
  }
}

Future<void> signOut() async {
  try {
    FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e);
  }
}

Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

Future<void> verifyEmail() async {
  User? user = FirebaseAuth.instance.currentUser;
  user!.sendEmailVerification();
}

Future<void> resetEmail(String email) async {
  User? user = FirebaseAuth.instance.currentUser;
  user!.updateEmail(email);
}

Future<void> changeAvatar(String photoURL) async {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var querySnapshots = await FirebaseFirestore.instance.doc("Users/$uid").get();
  querySnapshots.reference.update({"photoUrl": photoURL});
}

Future<void> userSetup(
    {required String uid,
    String displayname = "",
    required String email,
    String phone = ""}) async {
  await FirebaseFirestore.instance.doc("Users/$uid").set({
    "uid": uid,
    "displayName": displayname,
    'email': email,
    "phone": phone,
    "photoUrl":
        "https://firebasestorage.googleapis.com/v0/b/seniorproject2021-2.appspot.com/o/userImages%2Fperson-1767893-1502146.png?alt=media&token=6d7af57d-e1f2-4a82-8ad7-c7ffcda58def"
  });
}

Future<void> updateData(String displayname, String email) async {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var querySnapshots = await FirebaseFirestore.instance.doc("Users/$uid").get();
  querySnapshots.reference.update({"displayName": displayname, "email": email});
}

Future<String> pickSaveImage() async {
  var user = FirebaseAuth.instance.currentUser;
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  final _image = File(image!.path);
  final ref =
      FirebaseStorage.instance.ref().child("userImages").child(user!.uid);
  await ref.putFile(_image);
  var url = await ref.getDownloadURL();
  return url;
}
