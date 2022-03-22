import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccinationapp/scanner.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class QrCode extends StatelessWidget {
  QrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
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
                  "      Scanners will know your medical information,\nappointment details when they scan your QR code.",
                  style: TextStyle(color: FitnessAppTheme.grey, fontSize: 12),
                )),
            Positioned(
              bottom: 0.05 * height,
              child: SizedBox(
                width: 0.85 * width,
                height: 0.075 * height,
                child: ElevatedButton(
                  style: (ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          DesignCourseAppTheme.nearlyBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_scanner_sharp,
                        color: DesignCourseAppTheme.nearlyWhite,
                      ),
                      Text(
                        " Scan QR Code",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          letterSpacing: 0.0,
                          color: DesignCourseAppTheme.nearlyWhite,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Scanner();
                    }));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
