import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccinationapp/firebase/firebase.dart';
import 'package:vaccinationapp/info_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final Stream _usersStream =
        FirebaseFirestore.instance.doc("Users/$uid").snapshots();
    return Stack(children: [
      Container(color: const Color(0xff121421)),
      StreamBuilder<dynamic>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
                height: 0.3 * height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data['backgroundImg']),
                      fit: BoxFit.cover),
                ));
          }),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InfoPage();
                  }));
                },
              )
            ]),
        backgroundColor: Colors.transparent,
        body: Container(),
      ),
      StreamBuilder<dynamic>(
          stream: _usersStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Column(
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
                                          var imgUrl = await pickSaveImage();
                                          await changeAvatar(imgUrl.toString());
                                        },
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.photo_library),
                                        title: const Text(
                                            "Change Background Image"),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          var imgUrl = await pickSaveImage();
                                          await changeBI(imgUrl.toString());
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          // {
                          // var imgUrl = await pickSaveImage();
                          // await changeAvatar(imgUrl.toString());
                          // },
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
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12))),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(0.1 * width, 0.02 * height, 0, 0),
                  child: Column(
                    children: [
                      infoFormat(width, height, "Name", "Jessica Shmitz"),
                      infoFormat(width, height, "ID Card", "7 100 700 035 130"),
                      infoFormat(width, height, "Phone", "081 910 0231")
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.fromLTRB(0.05 * width, 0.05 * height, 0, 0),
                  child: Row(
                    children: [
                      infoBox(width, "Blood Group", "B+", Icons.bloodtype,
                          Colors.red[300]),
                      SizedBox(
                        width: 0.045 * width,
                      ),
                      infoBox(width, "Weight(kg)", "47.5",
                          Icons.accessibility_new, Colors.greenAccent),
                      SizedBox(
                        width: 0.045 * width,
                      ),
                      infoBox(width, "Height (cm)", "163", Icons.accessibility,
                          Colors.orange[300])
                    ],
                  ),
                ),
              ],
            );
          }),
    ]);
  }

  Row infoFormat(double width, double height, String title, String data) {
    return Row(
      children: [
        SizedBox(
            width: 0.2 * width,
            child: Text(title,
                style: const TextStyle(fontSize: 16, color: Colors.white))),
        Padding(
          padding: EdgeInsets.all(0.02 * height),
          child: Text(
            data,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 0.01 * width),
          Text(data,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
