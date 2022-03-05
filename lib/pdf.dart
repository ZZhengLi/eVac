import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

import 'mobile.dart';

class PDF extends StatelessWidget {
  PDF({Key? key}) : super(key: key);
  var uid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();
  late Stream _usersStream;
  late Stream _vaccinesStream;
  bool editState = false;
  late String _gender;
  late DateTime _dob;
  late String _name,
      _idCard,
      _address,
      _nationality,
      _email,
      _phone,
      _bloodGroup,
      _weight,
      _height,
      _dose_number1;

  late QueryDocumentSnapshot data;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final vaccines = FirebaseFirestore.instance
        .doc("Users/$uid")
        .collection("Vaccinations")
        .orderBy("time", descending: true);

    uid = user!.uid;
    _usersStream = FirebaseFirestore.instance.doc("Users/$uid").snapshots();

    EasyLoading.dismiss();

    return StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var user = snapshot.data;

          EasyLoading.dismiss();
          return StreamBuilder(
              stream: vaccines.snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot2) {
                var vaccines = snapshot2.data;
                return Container(
                  child: ElevatedButton(
                    onPressed: () => _createPDF(
                        user["displayName"],
                        user["dob"].toDate(),
                        user["gender"],
                        user["id"],
                        user["address"],
                        "dose_number1"),
                    child: Text("Create PDF"),
                  ),
                );
              });
        });
  }
}

Future<void> _createPDF(String _name, DateTime _dob, String _gender,
    String _idCard, String _address, String _dose_number1) async {
  PdfDocument document = PdfDocument();

// Add a PDF page and draw text.
  // final page = document.pages.add();

  final PdfPageTemplateElement headerTemplate =
      PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the header.
  headerTemplate.graphics.drawString(
    'Covid-19 Vaccination Certificate',
    PdfStandardFont(PdfFontFamily.helvetica, 25),
  );
//Add the header element to the document.
  document.template.top = headerTemplate;

//Create a PdfGrid
  PdfGrid grid = PdfGrid();

//Add the columns to the grid
  grid.columns.add(count: 2);
  grid.headers.add(1);
  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Beneficiary Details';
  header.cells[1].value = '';

  header.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);

//Add rows to grid
  PdfGridRow row1 = grid.rows.add();
  row1.cells[0].value = 'Beneficiary Name';
  row1.cells[1].value = _name;

  PdfGridRow row2 = grid.rows.add();
  row2.cells[0].value = 'Date of Birth';
  row2.cells[1].value = _dob;

  PdfGridRow row3 = grid.rows.add();
  row3.cells[0].value = 'Gender';
  row3.cells[1].value = _gender;

  PdfGridRow row4 = grid.rows.add();
  row4.cells[0].value = 'ID Card/Passport';
  row4.cells[1].value = _idCard;

  PdfGridRow row5 = grid.rows.add();
  row5.cells[0].value = 'Address';
  row5.cells[1].value = _address;

  //Apply the cell style to specific row1 cells
  grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, top: 5, bottom: 5),
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 13));
//Draw grid on the page of PDF document and store the grid position in PdfLayoutResult
  PdfLayoutResult result = grid.draw(
      page: document.pages.add(),
      bounds: const Rect.fromLTWH(0, 0, 0, 0)) as PdfLayoutResult;

//Create a second PdfGrid in the same page
  PdfGrid grid2 = PdfGrid();

//Add columns to second grid
  grid2.columns.add(count: 2);
  grid2.headers.add(1);
  PdfGridRow header1 = grid2.headers[0];
  header1.cells[0].value = 'Vaccination Details';
  header1.cells[1].value = '';

  header1.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);

//Add rows to grid
  PdfGridRow row11 = grid2.rows.add();
  row11.cells[0].value = 'Vaccine Name';
  row11.cells[1].value = 'Pfizer';

  PdfGridRow row12 = grid2.rows.add();
  row12.cells[0].value = 'Dose Number';
  row12.cells[1].value = _dose_number1;

  PdfGridRow row13 = grid2.rows.add();
  row13.cells[0].value = 'Date of Vaccine';
  row13.cells[1].value = '12/12/2022';

  PdfGridRow row14 = grid2.rows.add();
  row14.cells[0].value = 'Lot Number';
  row14.cells[1].value = '7841520154';

  PdfGridRow row15 = grid2.rows.add();
  row15.cells[0].value = 'Manufacturer';
  row15.cells[1].value = 'Place of Survice';

  grid2.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, top: 5, bottom: 5),
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 13));

//Draw the grid in PDF document page
  grid2.draw(
      page: result.page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 20, 0, 0));
  // Save the document.

  //Create a second PdfGrid in the same page
  PdfGrid grid3 = PdfGrid();

//Add columns to second grid
  grid3.columns.add(count: 2);
  grid3.headers.add(1);
  PdfGridRow header2 = grid3.headers[0];
  header2.cells[0].value = 'Vaccination Details';
  header2.cells[1].value = '';

  header2.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
//Add rows to grid
  PdfGridRow row21 = grid3.rows.add();
  row21.cells[0].value = 'Vaccine Name';
  row21.cells[1].value = 'Pfizer';

  PdfGridRow row22 = grid3.rows.add();
  row22.cells[0].value = 'Dose Number';
  row22.cells[1].value = '1st Dose';

  PdfGridRow row23 = grid3.rows.add();
  row23.cells[0].value = 'Date of Vaccine';
  row23.cells[1].value = '12/12/2022';

  PdfGridRow row24 = grid3.rows.add();
  row24.cells[0].value = 'Lot Number';
  row24.cells[1].value = '7841520154';

  PdfGridRow row25 = grid3.rows.add();
  row25.cells[0].value = 'Manufacturer';
  row25.cells[1].value = 'Place of Survice';

  grid3.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, top: 5, bottom: 5),
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 13));

//Draw the grid in PDF document page
  grid3.draw(
      page: result.page,
      bounds: Rect.fromLTWH(0, result.bounds.bottom + 215, 0, 0));

  // Save the document.
  List<int> bytes = document.save();

  document.dispose();
  // saveAndLaunchFile(bytes, "Certificate.pdf");
  // openFile(bytes, "Output.pdf");
  final path = (await getExternalStorageDirectory())!.path;
  final file = File("$path/Certificate.pdf");
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open("$path/Certificate.pdf");
}
