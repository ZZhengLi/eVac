import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/certificate_detail.dart';

class Vaccinations extends StatefulWidget {
  Vaccinations({Key? key}) : super(key: key);

  @override
  State<Vaccinations> createState() => _VaccinationsState();
}

class _VaccinationsState extends State<Vaccinations> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  late List myVaccinations;
  late String id, name;
  final vaccines = FirebaseFirestore.instance.collection("Vaccinations");

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.doc("Users/$uid").get().then((snapshot) {
      myVaccinations = snapshot.data()!["vaccinations"];
    });
    return StreamBuilder(
      stream: vaccines.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          EasyLoading.dismiss();
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        EasyLoading.dismiss();
        // return ListView.builder(
        //     itemCount: myVaccinations.length,
        //     itemBuilder: (context, index) {
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot element) =>
                          element["id"].toString().contains("abc"))
                      .map((QueryDocumentSnapshot data) {
                    final String id = data["id"];
                    final String name = data["name"];

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(id),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CertificateDetail(data: data)));
                      },
                    );
                  })
                ],
              );
      //       });
      },
    );
  }
}
// ListView.builder(
//             itemCount: vaccinations.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(vaccinations[index]),
//               );
//             })
