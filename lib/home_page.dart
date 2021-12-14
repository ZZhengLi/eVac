import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaccinationapp/detail_page.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/qr_code.dart';
import 'package:vaccinationapp/drawer.dart';
import 'package:vaccinationapp/vaccination_certificates.dart';
import 'package:vaccinationapp/widgets/discover_card.dart';
import 'package:vaccinationapp/widgets/discover_small_card.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);
  var uid = FirebaseAuth.instance.currentUser!.uid;
  var data1, data2;
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
        // .where("time",
        //     isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy("time", descending: true)
        .limit(1)
        .snapshots();
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Home"),
          elevation: 0,
          backgroundColor: const Color(0xff121421),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.qr_code),
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
                            if (snapshot1.hasError) {
                              EasyLoading.dismiss();
                              return const Text('Something went wrong');
                            }

                            if (snapshot1.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            if (snapshot2.hasError) {
                              EasyLoading.dismiss();
                              return const Text('Something went wrong');
                            }

                            if (snapshot2.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            data1 = snapshot1.data.docs[0];
                            data2 = snapshot2.data.docs[0];

                            return Row(
                              children: [
                                data1["date"].toDate().isAfter(DateTime(2000))
                                    ? DiscoverCard(
                                        tag: "latestVaccination",
                                        onTap: onLatestVaccinationTapped,
                                        title: "Latest Vaccination",
                                        subtitle:
                                            "${data1["name"]}\n\n\n\n${data1["date"].toDate().year}-${data1["date"].toDate().month}-${data1["date"].toDate().day}",
                                      )
                                    : DiscoverCard(
                                        tag: "latestVaccination",
                                        onTap: () {},
                                        title: "Latest Vaccination",
                                        subtitle:
                                            "You haven't taken any vaccination",
                                      ),
                                SizedBox(width: 20.w),
                                data2["time"].toDate().isAfter(DateTime.now())
                                    ? DiscoverCard(
                                        onTap: onNextAppointmentTapped,
                                        title: "Next Appointment",
                                        subtitle:
                                            "Your next appointment is on ${data2["time"].toDate().year}-${data2["time"].toDate().month}-${data2["time"].toDate().day}",
                                        gradientStartColor:
                                            const Color(0xffFC67A7),
                                        gradientEndColor:
                                            const Color(0xffF6815B),
                                      )
                                    : DiscoverCard(
                                        onTap: () {},
                                        title: "Next Appointment",
                                        subtitle:
                                            "You don't have any upcoming appointment",
                                        gradientStartColor:
                                            const Color(0xffFC67A7),
                                        gradientEndColor:
                                            const Color(0xffF6815B),
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
                "More",
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
                    crossAxisCount: 2,
                    crossAxisSpacing: 19.w,
                    mainAxisExtent: 125.w,
                    mainAxisSpacing: 19.w),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  DiscoverSmallCard(
                    onTap: onVCTapped,
                    title: "Vaccination Certificates",
                    gradientStartColor: const Color(0xff13DEA0),
                    gradientEndColor: const Color(0xff06B782),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "Hospital Info",
                    gradientStartColor: const Color(0xffFC67A7),
                    gradientEndColor: const Color(0xffF6815B),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "Vaccinations info",
                    gradientStartColor: const Color(0xffFFD541),
                    gradientEndColor: const Color(0xffF0B31A),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "More",
                  ),
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
    Get.to(() => Vaccinations(), transition: Transition.zoom);
  }

  void onLatestVaccinationTapped() {
    Get.to(() => const DetailPage(),
        transition: Transition.rightToLeftWithFade);
  }

  void onNextAppointmentTapped() {}

  void onSearchIconTapped() {}
}
