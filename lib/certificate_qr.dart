import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccinationapp/scanner.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class CQrCode extends StatelessWidget {
  CQrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0.1 * height,
              child: Container(
                  color: Colors.white,
                  child: QrImage(
                    data: uid,
                    size: 0.8 * width,
                  )),
            ),
            Positioned(
                bottom: 0.2 * height,
                child: const Text(
                  "Scanners will see your vaccination certificate \nwhen they scan your QR code.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: FitnessAppTheme.grey,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
