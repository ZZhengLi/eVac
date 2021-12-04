import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaccinationapp/home_page.dart';
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
    return ScreenUtilInit(
        builder: () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(),
            home: user == null ? const SignInPage() : const HomePage(),
            builder: EasyLoading.init()));
  }
}
