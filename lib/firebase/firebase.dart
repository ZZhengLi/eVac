import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

Future<void> userSetup(
    {String displayname = "", required String email, String phone = ""}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  users.add({"displayName": displayname, 'email': email, "phone": phone});
}

Future<void> updateData(String displayname, String email) async {
  var querySnapshots = await FirebaseFirestore.instance
      .collection("Users")
      .where("email", isEqualTo: email)
      .get();
  querySnapshots.docs[0].reference
      .update({"displayName": displayname, "email": email});
}
