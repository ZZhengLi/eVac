import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HistoryAppointments extends StatelessWidget {
  HistoryAppointments({Key? key}) : super(key: key);

  var uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final vaccines = FirebaseFirestore.instance
        .doc("Users/$uid")
        .collection("Appointment")
        .orderBy("time", descending: true);
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
            title: const Text("History Appointments"),
            elevation: 0,
            backgroundColor: const Color(0xff121421),
          ),
          backgroundColor: const Color(0xff121421),
          body: SafeArea(
            child: ListView(
              children: [
                ...snapshot.data!.docs.map((QueryDocumentSnapshot data) {
                  final DateTime time = data["time"].toDate();

                  return time.isAfter(DateTime(2000))
                      ? Card(
                          color: const Color(0xff263950),
                          child: ListTile(
                              title: Text(
                                  "${time.year.toString()}-${time.month.toString()}-${time.day.toString()}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ))),
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
