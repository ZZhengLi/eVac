import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/reset_password.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Positioned(
              child: SizedBox(
                width: 380,
                height: 50,
                child: ElevatedButton(
                  style: (ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          DesignCourseAppTheme.nearlyBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )))),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.left,
                    children: const [
                      Text(
                        "Reset Password",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: DesignCourseAppTheme.nearlyWhite,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: DesignCourseAppTheme.nearlyWhite,
                      ),
                    ],
                  ),
                  onPressed: () {
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPassword();
                    }));
                    EasyLoading.dismiss();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
