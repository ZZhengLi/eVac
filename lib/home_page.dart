import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vaccinationapp/next_appointment.dart';
import 'package:vaccinationapp/pdf.dart';
import 'package:vaccinationapp/qr_code.dart';
import 'package:vaccinationapp/taken_vaccine.dart';
import 'package:vaccinationapp/drawer.dart';
import 'package:vaccinationapp/latest_vaccination.dart';
import 'package:vaccinationapp/vaccine_info.dart';
import 'package:vaccinationapp/widgets/discover_card.dart';
import 'package:vaccinationapp/widgets/discover_small_card.dart';
import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var data1, data2, latest;
  @override
  Widget build(BuildContext context) {
    final vaccines = FirebaseFirestore.instance
        .doc("Users/$uid")
        .collection("Vaccinations")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    final appointment = FirebaseFirestore.instance
        .doc("Users/$uid")
        .collection("Appointment")
        .where("time",
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime.now().subtract(const Duration(
              days: 1,
            ))))
        .orderBy("time")
        .limit(1)
        .snapshots();
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: DesignCourseAppTheme.darkerText,
          ),
          centerTitle: true,
          title: const Text("Home",
              style: TextStyle(
                  color: DesignCourseAppTheme.darkerText,
                  fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          elevation: 0,
          backgroundColor: const Color(0xffffffff),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.qr_code, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return QrCode();
                }));
              },
            )
          ]),
      drawer: const DrawerPage(),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended",
                    style: TextStyle(
                        color: const Color(0xff515979),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.w),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            SizedBox(
              height: 176.w,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(width: 28.w),
                  StreamBuilder(
                    stream: vaccines,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot1) {
                      return StreamBuilder(
                          stream: appointment,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot2) {
                            if (snapshot1.hasError || snapshot2.hasError) {
                              EasyLoading.dismiss();
                              return const Text('Something went wrong');
                            }

                            if (snapshot1.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot2.connectionState ==
                                    ConnectionState.waiting) {
                              return const Text("Loading");
                            }

                            data1 = snapshot1.data.docs[0];
                            latest = data1["latest"];
                            data2 = snapshot2.data.docs[0];

                            return Row(
                              children: [
                                DiscoverCard(
                                  tag: "latestVaccination",
                                  onTap: () => onVTapped(data1),
                                  title: "Latest Vaccination",
                                  subtitle: data1["latest"] != "0"
                                      ? "${data1["vaccine_name$latest"]}\n\n\n\n${data1["date$latest"].toDate().year.toString()}-${data1["date$latest"].toDate().month.toString().padLeft(2, '0')}-${data1["date$latest"].toDate().day.toString().padLeft(2, '0')}"
                                      : "You haven't taken any vaccination",
                                ),
                                SizedBox(width: 20.w),
                                DiscoverCard(
                                  onTap: onHATapped,
                                  title: "Next Appointment",
                                  subtitle: data2["time"]
                                          .toDate()
                                          .isBefore(DateTime(2200))
                                      ? "Your next appointment is on\n\n\n\n${data2["time"].toDate().year.toString()}-${data2["time"].toDate().month.toString().padLeft(2, '0')}-${data2["time"].toDate().day.toString().padLeft(2, '0')}"
                                      : "You don't have any upcoming appointment",
                                  gradientStartColor: const Color(0xffFC67A7),
                                  gradientEndColor: const Color(0xffF6815B),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.only(left: 28.w),
              child: Text(
                "Others",
                style: TextStyle(
                    color: const Color(0xff515979),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.w),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 19.w,
                    mainAxisExtent: 125.w,
                    mainAxisSpacing: 19.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DiscoverSmallCard(
                      onTap: onVCTapped,
                      title: "Vaccine Certificates",
                      gradientStartColor: const Color(0xff13DEA0),
                      gradientEndColor: const Color(0xff06B782),
                      icon: SvgPicture.asset("assets/icons/vaccines.svg",
                          color: Colors.white, semanticsLabel: 'vaccines'),
                      subtitle: "Get your vaccination certificate here"),
                  DiscoverSmallCard(
                      onTap: onVSTapped,
                      title: "Details of Vaccines",
                      gradientStartColor: const Color(0xffFFD541),
                      gradientEndColor: const Color(0xffF0B31A),
                      icon: const Icon(Icons.info, color: Colors.white),
                      subtitle: "Get more details about vaccines here"),
                  // DiscoverSmallCard(
                  //     onTap: onCtapped,
                  //     title: "Don't know",
                  //     gradientStartColor: const Color(0xffFC67A7),
                  //     gradientEndColor: const Color(0xffF6815B),
                  //     icon: const Icon(Icons.local_hospital,
                  //         color: Colors.white)),
                  // DiscoverSmallCard(
                  //     onTap: onHATapped,
                  //     title: "Don't know",
                  //     icon: const Icon(Icons.history, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onVCTapped() {
    // EasyLoading.show(maskType: EasyLoadingMaskType.black);
    Get.to(() => TakenVaccine(), transition: Transition.zoom);
  }

  void onHATapped() {
    // EasyLoading.show(maskType: EasyLoadingMaskType.black);
    Get.to(() => NextAppointment(), transition: Transition.zoom);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const MyDiaryScreen()),
    // );
  }

  void onVSTapped() {
    // EasyLoading.show(maskType: EasyLoadingMaskType.black);
    Get.to(() => Vaccinations_Info(), transition: Transition.zoom);
  }

  void onVTapped(QueryDocumentSnapshot<Object?> data) {
    Get.to(() => LatestVaccination(data: data), transition: Transition.zoom);
  }
}
