import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpPage({Key? key}) : super(key: key);

  late String _fullName, _email, _password, _phoneNumber;

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
        // backgroundColor: Color(0xff121421),
        body:
            // SvgPicture.asset(
            //   "assets/icons/Sign_Up_bg.svg",
            //   height: MediaQuery.of(context).size.height,
            //   // Now it takes 100% of our height
            // ),
            Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  0.05 * width, 0.01 * height, 0.05 * width, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 50),
                  ),
                  Row(
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            )),
                        child: const Text(
                          "Sign In!",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                        const TextFieldName(text: "Full Name"),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: "Your Name Here"),
                          validator: RequiredValidator(
                              errorText: "Full Name is required"),
                          onSaved: (fullName) => _fullName = fullName!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const TextFieldName(text: "Email"),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              const InputDecoration(hintText: "yourEmail@email.com"),
                          validator:
                              EmailValidator(errorText: "Enter a valid email address"),
                          onSaved: (email) => _email = email!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const TextFieldName(text: "Phone"),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(hintText: "+123487697"),
                          validator: RequiredValidator(
                              errorText: "Phone number is required"),
                          onSaved: (phoneNumber) => _phoneNumber = phoneNumber!,
                        ),
                        SizedBox(height: 0.025 * height),
                        const TextFieldName(text: "Password"),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(hintText: "********"),
                          validator: passwordValidator,
                          onSaved: (password) => _password = password!,
                          onChanged: (pass) => _password = pass,
                        ),
                        SizedBox(height: 0.025 * height),
                        const TextFieldName(text: "Confirm Password"),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(hintText: "********"),
                          validator: (pass) => MatchValidator(
                                  errorText: "Password do not  match")
                              .validateMatch(pass!, _password),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0.05 * width),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          EasyLoading.show();
                          try {
                            UserCredential user = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            userSetup(
                                displayname: _fullName,
                                email: _email,
                                phone: _phoneNumber);
                            EasyLoading.showSuccess("Sign Up Successfully!");
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }));
                          } catch (e) {
                            EasyLoading.showError(e.toString());
                          }
                        }
                      },
                      child: const Text("Sign Up"),
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
        style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
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
