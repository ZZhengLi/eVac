import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccinationapp/forgot_password.dart';
import 'package:vaccinationapp/home_page.dart';
import 'package:vaccinationapp/user/sign_up_page.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class SignInPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  SignInPage({Key? key}) : super(key: key);
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffffffff),
          body: Column(children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0.12 * width, 0.1 * height, 0, 0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Row(children: const [
                  Text(
                    "Welcome!\nSign In Now", //Welcome text
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: DesignCourseAppTheme.nearlyBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ])),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0.15 * width, 0, 0, 0),
                    child: const Text("\nIf you are new /  ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ))),
                Text.rich(TextSpan(
                    text: "\nSign up",
                    style: const TextStyle(
                        fontSize: 15,
                        color: DesignCourseAppTheme.nearlyBlue,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(context,
                            CupertinoPageRoute(builder: (context) {
                          return SignUpPage();
                        }));
                      }))
              ],
            ),
            SizedBox(
              height: 0.05 * height,
            ),
            Container(
              alignment: Alignment.center,
              height: 0.2 * height,
              width: 0.7 * width,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: InputDecoration(
                          hintText: "Email",
                          fillColor: const Color(0xfff2f3f8),
                          filled: true,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff2f3f8)),
                              borderRadius: BorderRadius.circular(10))),
                      validator: EmailValidator(
                          errorText: "Enter a valid email address"),
                      onSaved: (email) => _email = email!,
                    ),
                    SizedBox(
                      height: 0.03 * height,
                    ),
                    //input password box
                    TextFormField(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          fillColor: const Color(0xfff2f3f8),
                          filled: true,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff2f3f8)),
                              borderRadius: BorderRadius.circular(10))),
                      onSaved: (password) => _password = password!,
                      onFieldSubmitted: (v) async {
                        await signInMethod(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0.15 * width, 0, 0, 0),
                    child: const Text("\n Forgot your password? /  ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ))),
                //Reset button
                Text.rich(TextSpan(
                    text: "\nReset",
                    style: const TextStyle(fontSize: 13, color: Colors.red),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return ForgotPassword();
                        }));
                      }))
              ],
            ),
            SizedBox(
              height: 0.09 * height,
            ),
            SizedBox(
              width: 0.7 * width,

              height: 45,
              //Sign in button
              child: ElevatedButton(
                  style: (ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          DesignCourseAppTheme.nearlyBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )))),
                  onPressed: () async {
                    await signInMethod(context);
                  },
                  child: const Text("Sign In",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: DesignCourseAppTheme.nearlyWhite,
                      ))),
            ),
          ]),
        ));
  }

  //Sign in with firebase and loading animation
  Future<void> signInMethod(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        EasyLoading.dismiss();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    }
  }
}
