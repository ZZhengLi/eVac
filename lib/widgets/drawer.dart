import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/profile.dart';
import 'package:vaccinationapp/setting.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';

class drawer extends StatefulWidget {
  drawer({Key? key}) : super(key: key);

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final Stream _usersStream =
        FirebaseFirestore.instance.doc("Users/$uid").snapshots();
    return Drawer(
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
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        return UserAccountsDrawerHeader(
                          margin: const EdgeInsets.all(0),
                          accountName: Text(snapshot.data['displayName']),
                          accountEmail: Text(snapshot.data['email']),
                          currentAccountPicture: CircleAvatar(
                              // foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (NetworkImage(snapshot.data['photoUrl']))),
                          decoration: const BoxDecoration(
                              // color: Color(0xff121421),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/seniorproject2021-2.appspot.com/o/userImages%2Fbgp.jpg?alt=media&token=d01db687-8784-4d82-a64b-14abd021e602"),
                                  fit: BoxFit.cover)),
                        );
                      }))
            ],
          ),
          Container(
            color: const Color(0xff263950),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xff263950),
                    child: Icon(Icons.person),
                  ),
                  title: const Text("Profile",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProfilePage();
                    }));
                  },
                ),
                ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xff263950),
                      child: Icon(Icons.settings),
                    ),
                    title: const Text("Setting",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
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
              color: const Color(0xff263950),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.logout),
                ),
                title: const Text("Sign Out",
                    style: TextStyle(color: Colors.white)),
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
            ),
          ),
        ],
      ),
    );
  }
}
