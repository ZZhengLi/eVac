import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/profile.dart';
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
                          decoration:
                              const BoxDecoration(color: Color(0xff121421)),
                          currentAccountPicture: CircleAvatar(
                              // foregroundColor: Colors.white,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (NetworkImage(snapshot.data['photoUrl']))),
                          accountName: Text(snapshot.data['displayName']),
                          accountEmail: Text(snapshot.data['email']),
                        );
                      }))
            ],
          ),
          Container(
            color: const Color(0xff263950),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff263950),
                child: Icon(Icons.person),
              ),
              title:
                  const Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProfilePage();
                }));
              },
            ),
          ),
          Container(
            color: const Color(0xff263950),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xff263950),
                child: Icon(Icons.settings),
              ),
              title:
                  const Text("Setting", style: TextStyle(color: Colors.white)),
              onTap: () {},
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
