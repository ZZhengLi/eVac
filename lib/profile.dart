import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/info_page.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final Stream _usersStream =
        FirebaseFirestore.instance.doc("Users/$uid").snapshots();
    return StreamBuilder<dynamic>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            EasyLoading.dismiss();
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          EasyLoading.dismiss();
          return Stack(children: [
            Container(color: const Color(0xffffffff)),
            Container(
                height: 0.3 * height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data['backgroundImg']),
                      fit: BoxFit.cover),
                )),
            Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: const Text("My Profile"),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.list),
                      onPressed: () {
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const InfoPage();
                        }));
                      },
                    )
                  ]),
              backgroundColor: Colors.transparent,
              body: Container(),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0.3 * height - 81, 0, 0),
                      child: CircleAvatar(
                        radius: 81,
                        backgroundColor: Colors.white,
                        child: InkWell(
                          onTap: () async {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text("Change Avatar"),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          var imgUrl =
                                              await pickSaveImage("avatar");
                                          await changeImg(
                                              imgUrl.toString(), "photoUrl");
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text(
                                            "Change Background Image"),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          var imgUrl = await pickSaveImage(
                                              "backgroundImg");

                                          await changeImg(imgUrl.toString(),
                                              "backgroundImg");
                                          EasyLoading.dismiss();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  (NetworkImage(snapshot.data['photoUrl']))),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            0.1 * width, 0.03 * height, 0, 0),
                        child: const Text("Personal Info",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(0.1 * width, 0.02 * height, 0, 0),
                  child: Column(
                    children: [
                      infoFormat(
                          width, height, "Name", snapshot.data["displayName"]),
                      infoFormat(width, height, "ID Card", snapshot.data["id"]),
                      infoFormat(
                          width, height, "Phone", snapshot.data["phone"]),
                      infoFormat(width, height, "Nationality",
                          snapshot.data["nationality"])
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(0.05 * width, 0.05 * height, 0, 0),
                  child: Row(
                    children: [
                      infoBox(width, "Blood Group", snapshot.data["bloodGroup"],
                          Icons.bloodtype, const Color(0xff62B4FF)),
                      SizedBox(
                        width: 0.045 * width,
                      ),
                      infoBox(width, "Weight(kg)", snapshot.data["weight"],
                          Icons.accessibility_new, const Color(0xff62B4FF)),
                      SizedBox(
                        width: 0.045 * width,
                      ),
                      infoBox(width, "Height (cm)", snapshot.data["height"],
                          Icons.accessibility, const Color(0xff62B4FF))
                    ],
                  ),
                ),
              ],
            ),
          ]);
        });
  }

  Row infoFormat(double width, double height, String title, String data) {
    return Row(
      children: [
        SizedBox(
            width: 0.25 * width,
            child: Text(title,
                style: const TextStyle(
                    fontSize: 17,
                    color: DesignCourseAppTheme.nearlyBlue,
                    fontWeight: FontWeight.bold))),
        Padding(
          padding: EdgeInsets.all(0.02 * height),
          child: Text(
            data,
            style: const TextStyle(fontSize: 17, color: Color(0x8A000000)),
          ),
        ),
      ],
    );
  }

  Container infoBox(
      double width, String name, String data, IconData icon, Color? color) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      height: 0.27 * width,
      width: 0.27 * width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          SizedBox(height: 0.01 * width),
          Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
          SizedBox(height: 0.01 * width),
          Text(data,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
