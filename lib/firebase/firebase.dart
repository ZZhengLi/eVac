import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

Future<void> changeImg(String photoURL, String img) async {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var querySnapshots = await FirebaseFirestore.instance.doc("Users/$uid").get();
  querySnapshots.reference.update({img: photoURL});
}

Future<void> userSetup(
    {required String uid,
    String displayname = "",
    required String email,
    String phone = "",
    required String id}) async {
  await FirebaseFirestore.instance.doc("Users/$uid").set({
    "uid": uid,
    "verification": false,
    "displayName": displayname,
    "email": email,
    "phone": phone,
    "id": id,
    "height": "",
    "weight": "",
    "bloodGroup": "",
    "dob": Timestamp.fromDate(DateTime.now()),
    "address": "",
    "nationality": "",
    "gender": "Male",
    "photoUrl":
        "https://firebasestorage.googleapis.com/v0/b/seniorproject2021-2.appspot.com/o/userImages%2Fperson-1767893-1502146.png?alt=media&token=6d7af57d-e1f2-4a82-8ad7-c7ffcda58def",
    "backgroundImg":
        "https://firebasestorage.googleapis.com/v0/b/seniorproject2021-2.appspot.com/o/userImages%2FMicrosoftTeams-image1.png?alt=media&token=b90060a6-7c3a-49f3-8522-3d109497b9e1"
  }, SetOptions(merge: true));
  await FirebaseFirestore.instance
      .doc("Users/$uid")
      .collection("Vaccinations")
      .doc("default")
      .set({
    "vaccine_name1": "default",
    "latest": "0",
    "date": Timestamp.fromDate(DateTime(2222))
  });
  await FirebaseFirestore.instance
      .doc("Users/$uid")
      .collection("Appointment")
      .doc("default")
      .set({"time": Timestamp.fromDate(DateTime(2222))});
}

Future<void> updateData(
    String displayname, String email, String address) async {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var querySnapshots = await FirebaseFirestore.instance.doc("Users/$uid").get();
  querySnapshots.reference
      .update({"displayName": displayname, "email": email, "address": address});
}

Future<String> pickSaveImage(String img) async {
  var user = FirebaseAuth.instance.currentUser;
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  final _image = File(image!.path);
  final ref = FirebaseStorage.instance
      .ref()
      .child("userImages")
      .child(user!.uid)
      .child(img);
  await ref.putFile(_image);
  var url = await ref.getDownloadURL();
  return url;
}
