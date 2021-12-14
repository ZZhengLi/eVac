import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();

    return Container(
      child: ElevatedButton(
        onPressed: () {
          // var list = ["abc","123"];
          // FirebaseFirestore.instance
          //     .doc("Users/$uid")
          //     .update({"vaccinations": FieldValue.arrayUnion(list)});
        },
        child: Text("D"),
      ),
    );
  }
}

Future<void> upload() async {
  // Create a new PDF document.
  final PdfDocument document = PdfDocument();
// Add a PDF page and draw text.
  document.pages.add().graphics.drawString(
      'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTWH(0, 0, 150, 20));
// Save the document.
  List<int> bytes = document.save();

  document.dispose();
  openFile(bytes, "Output.pdf");
}

Future<void> openFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())!.path;
  final file = File("$path/$fileName");
  await file.writeAsBytes(bytes, flush: true);
  // OpenFile.open("$path/$fileName");
  final ref = FirebaseStorage.instance.ref().child("pdf").child("pdf");
  await ref.putFile(file);
}
