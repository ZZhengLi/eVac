import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool flash = false;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late final String _uid;
  late bool exist;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        SafeArea(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  icon: Icon(
                    flash ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      if (flash) {
                        flash = false;
                      } else {
                        flash = true;
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 0.1 * width,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await controller?.flipCamera();
                  },
                ),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.05 * width, 0.04 * height, 0, 0),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              navigator?.pop();
            },
          ),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      if (await canLaunch(result!.code.toString())) {
        await launch(result!.code.toString(),
            forceSafariVC: true, forceWebView: true, enableJavaScript: true);
      } else {
        await FirebaseFirestore.instance
            .doc("QR/temp")
            .get()
            .then((value) async {
          if (result!.code.toString() == value.data()!["code"]) {
            EasyLoading.show(maskType: EasyLoadingMaskType.black);
            _uid = FirebaseAuth.instance.currentUser!.uid;
            await FirebaseFirestore.instance
                .doc("Users/$_uid")
                .collection("Vaccinations")
                .doc(value["name"])
                .get()
                .then((doc) {
              exist = doc.exists;
            });
            exist && _uid == value["uid"]
                ? await FirebaseFirestore.instance
                    .doc("Users/$_uid")
                    .collection("Vaccinations")
                    .doc(value["name"])
                    .update({
                    "vaccine_name${value["dose_number"]}": value["name"],
                    "lot_number${value["dose_number"]}": value["id"],
                    "manufacturer${value["dose_number"]}":
                        value["manufacturer"],
                    "date${value["dose_number"]}": value["date"],
                    "place_of_service${value["dose_number"]}":
                        value["place_of_service"],
                    "dose_number${value["dose_number"]}": value["dose_number"],
                    "latest": value["dose_number"],
                    "date": value["date"],
                  })
                : await FirebaseFirestore.instance
                    .doc("Users/$_uid")
                    .collection("Vaccinations")
                    .doc(value["name"])
                    .set({
                    "vaccine_name${value["dose_number"]}": value["name"],
                    "lot_number${value["dose_number"]}": value["id"],
                    "manufacturer${value["dose_number"]}":
                        value["manufacturer"],
                    "date${value["dose_number"]}": value["date"],
                    "place_of_service${value["dose_number"]}":
                        value["place_of_service"],
                    "dose_number${value["dose_number"]}": value["dose_number"],
                    "latest": value["dose_number"],
                    "date": value["date"],
                  });
            await FirebaseFirestore.instance
                .doc("Users/$_uid")
                .collection("Appointment")
                .doc(value["name"] + value["dose_number"])
                .delete();
            await _createPDF(
              value["displayName"],
              value["dob"].toDate(),
              value["gender"],
              value["idC"],
              value["address"],
              value["dose_number"],
              _uid,
              value["name"],
            );
            await FirebaseFirestore.instance
                .doc("Users/$_uid")
                .collection("Vaccinations")
                .doc("default")
                .delete();
            await FirebaseFirestore.instance.doc("QR/temp").delete();

            EasyLoading.showSuccess(
                "New vaccine certificate received successfully!");
            Navigator.pop(context);
          } else {
            EasyLoading.showError(
                "QR Code may be expired or not belong to you, plase try again");
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

Future<void> _createPDF(
    String _name,
    DateTime _dob,
    String _gender,
    String _idCard,
    String _address,
    String _doseNumber,
    String uid,
    String _vaccineName) async {
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
  row11.cells[1].value = 'Pfizer2';

  PdfGridRow row12 = grid2.rows.add();
  row12.cells[0].value = 'Dose Number';
  row12.cells[1].value = _doseNumber;

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
  final ref = FirebaseStorage.instance
      .ref()
      .child("pdf")
      .child(uid)
      .child(_vaccineName);
  await ref.putFile(file);
  var url = await ref.getDownloadURL();
  await FirebaseFirestore.instance
      .doc("Users/$uid")
      .collection("Vaccinations")
      .doc(_vaccineName)
      .update({"url": url.toString()});
}
