import 'package:vaccinationapp/home_page.dart';

import '../user/sign_in_page.dart';
import '../user/sign_up_page.dart';

final Map<String, Function> routes={
  '/':(context)=>HomePage(),
  '/signInPage':(context)=>SignInPage(),
  '/signUpPage':(context)=>SignUpPage(),

};