import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaccinationapp/certificate_detail.dart';

class Vaccinations extends StatefulWidget {
  Vaccinations({Key? key}) : super(key: key);

  @override
  State<Vaccinations> createState() => _VaccinationsState();
}

class _VaccinationsState extends State<Vaccinations> {
  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final vaccines = FirebaseFirestore.instance
        .doc("Users/$uid")
        .collection("Vaccinations")
        .orderBy("date", descending: true);
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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Certificates"),
            elevation: 0,
            backgroundColor: const Color(0xff121421),
          ),
          backgroundColor: const Color(0xff121421),
          body: SafeArea(
            child: ListView(
              children: [
                ...snapshot.data!.docs.map((QueryDocumentSnapshot data) {
                  final String id = data["id"];
                  final String name = data["name"];
                  final DateTime date = data["date"].toDate();

                  return date.isAfter(DateTime(2000))
                      ? InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              color: const Color(0xff263950),
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: SvgPicture.asset(
                                          "assets/icons/vaccines.svg",
                                          color: Colors.white,
                                          height: 40,
                                          semanticsLabel: 'vaccines'),
                                      title: Text(name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          )),
                                      subtitle: Text(id,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          )),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                        color: Colors.white,
                                      )),
                                  ListTile(
                                      title: Text(
                                          "${date.year.toString()}-${date.month.toString()}-${date.day.toString()}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                          )))
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CertificateDetail(data: data)));
                          },
                        )
                      : Container();
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
