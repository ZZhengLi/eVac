import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/profile.dart';
import 'package:vaccinationapp/setting.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  get color => null;

  @override
  Widget build(BuildContext context) {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final Stream _usersStream =
        FirebaseFirestore.instance.doc("Users/$uid").snapshots();

    return SizedBox(
        width: 0.75 * MediaQuery.of(context).size.width,
        child: Drawer(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: StreamBuilder<dynamic>(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasError) {
                              EasyLoading.dismiss();
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            EasyLoading.dismiss();
                            return UserAccountsDrawerHeader(
                              margin: const EdgeInsets.all(0),
                              accountName: Text(
                                snapshot.data['displayName'],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: FitnessAppTheme.grey),
                              ),
                              accountEmail: Text(
                                snapshot.data['email'],
                                style: const TextStyle(
                                    fontSize: 14, color: FitnessAppTheme.grey),
                              ),
                              currentAccountPicture: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: (NetworkImage(
                                      snapshot.data['photoUrl']))),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data['backgroundImg']),
                                    fit: BoxFit.cover),
                              ),
                            );
                          }))
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(
                    color: const Color(0xffffffff),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xffffffff),
                        child: Icon(Icons.person,
                            color: DesignCourseAppTheme.nearlyBlue),
                      ),
                      title: const Text("Profile",
                          style: TextStyle(
                              color: FitnessAppTheme.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      onTap: () {
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ProfilePage();
                        }));
                      },
                    ),
                    ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xffffffff),
                          child: Icon(
                            Icons.settings,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                        ),
                        title: const Text("Settings",
                            style: TextStyle(
                                color: FitnessAppTheme.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onTap: () {
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const Setting();
                            }),
                          );
                        })
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text("Sign Out",
                        style: TextStyle(
                            color: FitnessAppTheme.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Confirm',
                            ),
                            content: const Text(
                              'Are you sure to sign out?',
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('YES'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  EasyLoading.show(
                                      maskType: EasyLoadingMaskType.black);
                                  signOut();
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SignInPage();
                                  }));
                                  EasyLoading.dismiss();
                                },
                              ),
                              ElevatedButton(
                                child: const Text('NO'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
