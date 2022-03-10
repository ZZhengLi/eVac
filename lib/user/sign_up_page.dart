import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'sign_in_page.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpPage({Key? key}) : super(key: key);

  late String _fullName, _email, _password, _phoneNumber, _id;

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
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  0.05 * width, 0.01 * height, 0.05 * width, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "eVac",
                    style: TextStyle(
                        fontSize: 50,
                        color: DesignCourseAppTheme.nearlyBlue,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Text("Already have an account?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          )),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            )),
                        child: const Text(
                          "Sign In!",
                          style: const TextStyle(
                              fontSize: 15,
                              color: DesignCourseAppTheme.nearlyBlue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.05 * width),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const TextFieldName(text: "Full Name"),
                        TextFormField(
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Full Name",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          validator: RequiredValidator(
                              errorText: "Full Name is required"),
                          onSaved: (fullName) => _fullName = fullName!,
                        ),
                        SizedBox(height: 0.025 * height),
                        TextFormField(
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "ID Card(Thai)/Passport(Non-Thai)",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          validator: RequiredValidator(
                              errorText: "ID Card/Passport is required"),
                          onSaved: (id) => _id = id!,
                        ),
                        SizedBox(height: 0.025 * height),

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Email Address",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          validator: EmailValidator(
                              errorText: "Enter a valid email address"),
                          onSaved: (email) => _email = email!,
                        ),
                        SizedBox(height: 0.025 * height),

                        TextFormField(
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Phone Number",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          onSaved: (phoneNumber) => _phoneNumber = phoneNumber!,
                        ),
                        SizedBox(height: 0.025 * height),

                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Password",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          validator: passwordValidator,
                          onSaved: (password) => _password = password!,
                          onChanged: (pass) => _password = pass,
                        ),
                        SizedBox(height: 0.025 * height),

                        TextFormField(
                          obscureText: true,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              hintText: "Confirm Password",
                              fillColor: Color(0xfff2f3f8),
                              filled: true,
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xfff2f3f8)),
                              )),
                          validator: (pass) => MatchValidator(
                                  errorText: "Password does not  match")
                              .validateMatch(pass!, _password),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 45),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: (ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              DesignCourseAppTheme.nearlyBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )))),
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);
                          try {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            await _auth.createUserWithEmailAndPassword(
                                email: _email, password: _password);
                            final User? user = _auth.currentUser;
                            final _uid = user!.uid;
                            userSetup(
                                uid: _uid,
                                displayname: _fullName,
                                email: _email,
                                phone: _phoneNumber,
                                id: _id);
                            EasyLoading.showSuccess("Sign Up Successfully!");
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return SignInPage();
                            }));
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        }
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: DesignCourseAppTheme.nearlyWhite,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldName extends StatelessWidget {
  const TextFieldName({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        // style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
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
