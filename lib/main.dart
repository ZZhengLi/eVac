import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'pages/home_page.dart';
import 'user/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null? const SignInPage(): const homePage(),
      builder: EasyLoading.init());
    
  }
}
