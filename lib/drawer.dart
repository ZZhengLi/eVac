import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/profile.dart';
import 'package:vaccinationapp/setting.dart';
import 'package:vaccinationapp/user/sign_in_page.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
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
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          accountEmail: Text(snapshot.data['email']),
                          currentAccountPicture: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (NetworkImage(snapshot.data['photoUrl']))),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      snapshot.data['backgroundImg']),
                                  fit: BoxFit.cover)),
                        );
                      }))
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff263950),
              border: Border.all(
                color: const Color(0xff263950),
              ),
            ),
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
                      backgroundColor: Color(0xff263950),
                      child: Icon(Icons.settings),
                    ),
                    title: const Text("Setting",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Setting();
                        }),
                      );
                    })
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff263950),
                border: Border.all(
                  color: const Color(0xff263950),
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.logout),
                ),
                title: const Text("Sign Out",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm',
                            style: TextStyle(color: Colors.white)),
                        content: const Text('Are you sure to sign out?',
                            style: TextStyle(color: Colors.white)),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff263950))),
                            child: const Text('YES'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              EasyLoading.show();
                              signOut();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignInPage();
                              }));
                              EasyLoading.dismiss();
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff263950))),
                            child: const Text('NO'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        backgroundColor: const Color(0xff121421),
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
    );
  }
}
