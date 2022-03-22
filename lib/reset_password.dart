import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class ResetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ResetPassword({Key? key}) : super(key: key);
  late String _password;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: const Text(
            "Reset Password",
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
        body: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 0.8 * width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "New Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "*********",
                          fillColor: const Color(0xfff2f3f8),
                          filled: true,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff2f3f8)),
                              borderRadius: BorderRadius.circular(10))),
                      validator: passwordValidator,
                      onSaved: (password) => _password = password!,
                      onChanged: (pass) => _password = pass,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Confirm New Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "*********",
                          fillColor: const Color(0xfff2f3f8),
                          filled: true,
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xfff2f3f8)),
                              borderRadius: BorderRadius.circular(10))),
                      validator: (pass) =>
                          MatchValidator(errorText: "Password do not  match")
                              .validateMatch(pass!, _password),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 40),
                      child: SizedBox(
                        width: 400,

                        height: 45,
                        //Sign in button
                        child: ElevatedButton(
                            style: (ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    DesignCourseAppTheme.nearlyBlue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                EasyLoading.show(
                                    maskType: EasyLoadingMaskType.black);
                                try {
                                  final User? user =
                                      FirebaseAuth.instance.currentUser;
                                  await user!.updatePassword(_password);
                                  EasyLoading.showSuccess(
                                      "Password Reset Successfully!");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } catch (e) {
                                  EasyLoading.showError(e.toString());
                                }
                              }
                            },
                            child: const Text("Change Password",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.0,
                                  color: DesignCourseAppTheme.nearlyWhite,
                                ))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ],
);
