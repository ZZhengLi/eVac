import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccinationapp/firebase/firebase.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: const Text("uploadImg"),
        onPressed: () async {
          var imgUrl = await pickSaveImage();
          await changeAvatar(imgUrl.toString());
        },
      ),
    );
  }
}
