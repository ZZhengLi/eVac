import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

import 'fitness_app/fitness_app_theme.dart';

class ForgotPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ForgotPassword({Key? key}) : super(key: key);
  late String _email;

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
          appBar: AppBar(
              iconTheme: const IconThemeData(
                color: DesignCourseAppTheme.darkerText,
              ),
              centerTitle: true,
              title: const Text("Reset Password",
                  style: TextStyle(
                      color: DesignCourseAppTheme.darkerText,
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
              elevation: 0,
              backgroundColor: const Color(0xffffffff)),
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffffffff),
          body: Center(
            child: Column(children: <Widget>[
              SizedBox(height: 0.05 * height),
              Container(
                alignment: Alignment.center,
                height: 0.1 * height,
                width: 0.7 * width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
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
                    ],
                  ),
                ),
              ),
              const Text(
                "(A password reset email will be sent to your email)",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 0.25 * width,
                height: 0.05 * height,
                child: ElevatedButton(
                    style: (ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            DesignCourseAppTheme.nearlyBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )))),
                    onPressed: () async {
                      await signInMethod(context);
                    },
                    child: const Text("Confirm",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: DesignCourseAppTheme.nearlyWhite,
                        ))),
              ),
            ]),
          ),
        ));
  }

  //Sign in with firebase and loading animation
  Future<void> signInMethod(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        EasyLoading.showSuccess(
            "A password reset email has sent to your email");
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      } catch (e) {
        EasyLoading.showError(e.toString());
      }
    }
  }
}
