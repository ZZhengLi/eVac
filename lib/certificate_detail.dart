import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/certificate_qr.dart';
import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class CertificateDetail extends StatefulWidget {
  final data;
  CertificateDetail({Key? key, required DocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  State<CertificateDetail> createState() => CertificateDetailState();
}

class CertificateDetailState extends State<CertificateDetail> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final user = FirebaseFirestore.instance.doc("Users/$uid");

    final String latest = widget.data["latest"];

    return StreamBuilder(
      stream: user.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.dismiss();
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        EasyLoading.dismiss();
        return Scaffold(
            appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                centerTitle: true,
                title: const Text(
                  "Certificate Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.black),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CQrCode(url: widget.data["url"]);
                      }));
                    },
                  )
                ]),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Beneficiary Details",
                          style: TextStyle(
                              color: DesignCourseAppTheme.nearlyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 32, right: 23, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                              topRight: Radius.circular(15.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: FitnessAppTheme.grey.withOpacity(0.2),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 16, right: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 4, bottom: 9),
                                        child: Text(
                                          "Name:",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                DesignCourseAppTheme.nearlyBlue,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 14, left: 10),
                                          child: Text(
                                            snapshot.data["displayName"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: 0.0,
                                              color: FitnessAppTheme.grey
                                                  .withOpacity(0.7),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 9),
                                        child: const Text(
                                          "Date of Birth:",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                DesignCourseAppTheme.nearlyBlue,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14, left: 10),
                                        child: Text(
                                          "${snapshot.data["dob"].toDate().day.toString().padLeft(2, '0')}/${snapshot.data["dob"].toDate().month.toString().padLeft(2, '0')}/${snapshot.data["dob"].toDate().year.toString()}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 9),
                                        child: const Text(
                                          "Gender:",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                DesignCourseAppTheme.nearlyBlue,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14, left: 10),
                                        child: Text(
                                          snapshot.data["gender"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 9),
                                        child: Text(
                                          snapshot.data["nationality"] == "Thai"
                                              ? "ID Card:"
                                              : "Passport:",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                DesignCourseAppTheme.nearlyBlue,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 14, left: 10),
                                        child: Text(
                                          snapshot.data["id"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 10),
                    child: const Text(
                      "Vaccination Details",
                      style: TextStyle(
                          color: DesignCourseAppTheme.nearlyBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Column(children: [
                    newMethod(widget.data, 1),
                    int.parse(latest) > 1
                        ? newMethod(widget.data, 2)
                        : Container(),
                    int.parse(latest) > 2
                        ? newMethod(widget.data, 3)
                        : Container()
                  ]),
                ],
              ),
            ));
      },
    );
  }
}

Column newMethod(QueryDocumentSnapshot<Object?> data, int i) {
  return Column(children: [
    Container(
        padding: const EdgeInsets.only(left: 32, right: 23, top: 10),
        child: Container(
          decoration: BoxDecoration(
            color: FitnessAppTheme.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: FitnessAppTheme.grey.withOpacity(0.2),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Dose:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            data["dose_number$i"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Date:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            "${data["date$i"].toDate().day.toString().padLeft(2, '0')}/${data["date$i"].toDate().month.toString().padLeft(2, '0')}/${data["date$i"].toDate().year}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Vaccine Name:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            data["vaccine_name$i"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Manufacturer:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            data["manufacturer$i"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Lot No#:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            data["lot_number$i"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4, bottom: 9),
                          child: const Text(
                            "Location:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: DesignCourseAppTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 14, left: 10),
                          child: Text(
                            data["place_of_service$i"],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: FitnessAppTheme.grey.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ))
  ]);
}
