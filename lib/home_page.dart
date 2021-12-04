import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vaccinationapp/detail_page.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';
import 'package:vaccinationapp/widgets/category_boxes.dart';
import 'package:vaccinationapp/icons.dart';
import 'package:vaccinationapp/widgets/discover_card.dart';
import 'package:vaccinationapp/widgets/discover_small_card.dart';
import 'package:vaccinationapp/widgets/svg_asset.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121421),
      appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: const Color(0xff121421),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {},
            )
          ]),
      drawer: Drawer(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.logout),
            ),
            title: const Text("Sign Out"),
            onTap: () {
              EasyLoading.show();
              // signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const SignInPage();
              }));
              EasyLoading.dismiss();
            },
          ),
        ],
      )),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 28.w,
                right: 18.w,
                top: 36.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discover",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34.w,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    borderRadius: BorderRadius.circular(360),
                    onTap: onSearchIconTapped,
                    child: SizedBox(
                      height: 35.w,
                      width: 35.w,
                      child: Center(
                        child: SvgAsset(
                          assetName: AssetName.search,
                          height: 24.w,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120.h,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: 28.w,
                  ),
                  CategoryBoxes(
                    text: "Insomnia",
                    onPressed: (value) => print(value),
                  ),
                  CategoryBoxes(
                    text: "Depression",
                    onPressed: (value) => print(value),
                  ),
                  CategoryBoxes(
                    text: "Baby Sleep",
                    onPressed: (value) => print(value),
                  ),
                  CategoryBoxes(
                    text: "Insomnia",
                    onPressed: (value) => print(value),
                  ),
                ],
              ),
            ),
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
