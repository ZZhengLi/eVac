import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CertificateDetail extends StatelessWidget {
  final data;
  CertificateDetail(
      {Key? key, required QueryDocumentSnapshot<Object?> this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(data["name"]),
          subtitle: Text(data["id"]),
        )
      ],
    );
  }
}
