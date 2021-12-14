import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccinationapp/scanner.dart';

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
        centerTitle: true,
        title: const Text("My QR Code"),
        elevation: 0,
        backgroundColor: const Color(0xff121421),
      ),
      backgroundColor: const Color(0xff121421),
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
                  "Scan a QR code for more information ",
                  style: TextStyle(color: Colors.white),
                )),
            Positioned(
              bottom: 0.05 * height,
              child: SizedBox(
                width: 0.85 * width,
                height: 0.075 * height,
                child: ElevatedButton(
                  style: (ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.white))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_scanner_sharp,
                        color: Color(0xff121421),
                      ),
                      Text(
                        "Scan QR Code",
                        style: TextStyle(color: Color(0xff121421)),
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
