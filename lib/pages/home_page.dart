import 'package:flutter/material.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';

class homePage extends StatelessWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("HomePage"),
        ElevatedButton(
            onPressed: () {
              signOut();
              Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SignInPage();}));
            },
            child: Text("logOut"))
      ],
    ));
  }
}
