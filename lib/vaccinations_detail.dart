import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vaccinationapp/certificate_qr.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

var uid = FirebaseAuth.instance.currentUser!.uid;

class VaccinationsDetail extends StatelessWidget {
  final data;
  VaccinationsDetail(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final vaccines = FirebaseFirestore.instance
        .doc("VaccineDetail/rqVBsoTdgyAN4faYrWLx")
        .collection("DetailsOfVaccine");

    return StreamBuilder(
        stream: vaccines.snapshots(),
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
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                centerTitle: true,
                title: const Text(
                  "Vaccine Details",
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              backgroundColor: Colors.white,
              body: SafeArea(
                  child: ListView(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data["name"],
                        style: TextStyle(
                            color: DesignCourseAppTheme.nearlyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                    '${data["description"]} \n',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 2,
                      fontSize: 15,
                      color: Color(0xff5F727E),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Eligible Age",
                        style: TextStyle(
                            color: DesignCourseAppTheme.nearlyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                    '${data["eligible_age"]} \n',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 2,
                      fontSize: 15,
                      color: Color(0xff5F727E),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Side Effects",
                        style: TextStyle(
                            color: DesignCourseAppTheme.nearlyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Text(
                    '${data["side_effects"]} \n',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 2,
                      fontSize: 15,
                      color: Color(0xff5F727E),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                //   child: Text(
                //     "Throughout the rest of your body:\n Tiredness\n Headache \n Muscle Pain \n Chills \n Fever",
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       height: 2,
                //       fontSize: 15,
                //       color: Color(0xff5F727E),
                //     ),
                //   ),
                // ),
              ])));
        });
  }
}
