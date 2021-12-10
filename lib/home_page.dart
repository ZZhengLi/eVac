import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaccinationapp/detail_page.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/qr_code.dart';
import 'package:vaccinationapp/widgets/category_boxes.dart';
import 'package:vaccinationapp/widgets/drawer.dart';
import 'package:vaccinationapp/widgets/icons.dart';
import 'package:vaccinationapp/widgets/discover_card.dart';
import 'package:vaccinationapp/widgets/discover_small_card.dart';
import 'package:vaccinationapp/widgets/svg_asset.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                      onTap: onSeeAllTapped,
                      child: Text("See All",
                          style: TextStyle(
                              color: const Color(0xff4A80F0),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.w)))
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
                  DiscoverCard(
                    tag: "sleepMeditation",
                    onTap: onSleepMeditationTapped,
                    title: "Sleep Meditation",
                    subtitle: "7 Day Audio and Video Series",
                  ),
                  SizedBox(width: 20.w),
                  DiscoverCard(
                    onTap: onDepressionHealingTapped,
                    title: "Depression Healing",
                    subtitle: "10 Days Audio and Video Series",
                    gradientStartColor: const Color(0xffFC67A7),
                    gradientEndColor: const Color(0xffF6815B),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.only(left: 28.w),
              child: Text(
                "Recent",
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
                    onTap: () {},
                    title: "Calming Sounds",
                    gradientStartColor: const Color(0xff13DEA0),
                    gradientEndColor: const Color(0xff06B782),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "Insomnia",
                    gradientStartColor: const Color(0xffFC67A7),
                    gradientEndColor: const Color(0xffF6815B),
                    icon: SvgAsset(
                      assetName: AssetName.tape,
                      height: 24.w,
                      width: 24.w,
                    ),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "For Children",
                    gradientStartColor: const Color(0xffFFD541),
                    gradientEndColor: const Color(0xffF0B31A),
                  ),
                  DiscoverSmallCard(
                    onTap: () {},
                    title: "Tips For Sleeping",
                    icon: SvgAsset(
                      assetName: AssetName.tape,
                      height: 24.w,
                      width: 24.w,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSeeAllTapped() {}

  void onSleepMeditationTapped() {
    Get.to(() => const DetailPage(), transition: Transition.rightToLeft);
  }

  void onDepressionHealingTapped() {}

  void onSearchIconTapped() {}
}
