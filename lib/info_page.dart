import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();
  late Stream _usersStream;
  late String uid;
  bool editState = false;
  late String _gender;
  late DateTime _dob;
  late TextEditingController _name,
      _idCard,
      _address,
      _nationality,
      _email,
      _phone,
      _bloodGroup,
      _weight,
      _height;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    uid = user!.uid;
    _usersStream = FirebaseFirestore.instance.doc("Users/$uid").snapshots();
    FirebaseFirestore.instance.doc("Users/$uid").get().then((value) {
      _name = TextEditingController(text: value.data()!["displayName"]);
      _idCard = TextEditingController(text: value.data()!["id"]);
      _address = TextEditingController(text: value.data()!["address"]);
      _nationality = TextEditingController(text: value.data()!["nationality"]);
      _email = TextEditingController(text: value.data()!["email"]);
      _phone = TextEditingController(text: value.data()!["phone"]);
      _bloodGroup = TextEditingController(text: value.data()!["bloodGroup"]);
      _weight = TextEditingController(text: value.data()!["weight"]);
      _height = TextEditingController(text: value.data()!["height"]);
      _gender = value.data()!["gender"];
      _dob = value.data()!["dob"].toDate();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _idCard.dispose();
    _address.dispose();
    _nationality.dispose();
    _email.dispose();
    _phone.dispose();
    _bloodGroup.dispose();
    _weight.dispose();
    _height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(children: [
              Container(color: const Color(0xffffffff)),
              Container(
                height: 0.3 * height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data['backgroundImg']),
                      fit: BoxFit.cover),
                ),
              ),
              Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: const Text("My Profile"),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: <Widget>[
                      IconButton(
                          icon: editState
                              ? const Icon(Icons.done)
                              : const Icon(Icons.edit),
                          onPressed: () async {
                            if (editState) {
                              EasyLoading.show(
                                  maskType: EasyLoadingMaskType.black);
                              await FirebaseFirestore.instance
                                  .doc("Users/$uid")
                                  .set({
                                "displayName": _name.text,
                                "id": _idCard.text,
                                "gender": _gender,
                                "dob": Timestamp.fromDate(_dob),
                                "address": _address.text,
                                "nationality": _nationality.text,
                                "phone": _phone.text,
                                "bloodGroup": _bloodGroup.text,
                                "weight": _weight.text,
                                "height": _height.text
                              }, SetOptions(merge: true));
                              EasyLoading.dismiss();
                            }
                            setState(() {
                              if (editState) {
                                editState = false;
                              } else {
                                editState = true;
                              }
                            });
                          }),
                    ]),
                backgroundColor: Colors.transparent,
                body: Container(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 0.12 * height),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: (NetworkImage(snapshot.data['photoUrl'])),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(
                              0.1 * width, 0.07 * height, 0, 0),
                          child: const Text(
                            "Personal Info",
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      padding: EdgeInsets.fromLTRB(
                          0.1 * width, 0.02 * height, 0.1 * width, 0),
                      child: ListView(
                          padding: const EdgeInsets.only(top: 0),
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  infos(
                                      title: "Name",
                                      controller: _name,
                                      edit: false,
                                      keyboardType: TextInputType.name),
                                  infos(
                                      title: "ID Card/Passport",
                                      controller: _idCard,
                                      edit: false,
                                      keyboardType: TextInputType.text),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 0.06 * height,
                                          width: 0.3 * width,
                                          child: const Text(
                                            "Gender",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: 0.06 * height,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<dynamic>(
                                            dropdownColor:
                                                const Color(0xffffffff),
                                            hint: const Text('Gender',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Color(0x8A000000),
                                                )),
                                            value: _gender,
                                            items: <String>[
                                              'Male',
                                              'Female',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color(0x8A000000)),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: editState
                                                ? (T) {
                                                    setState(() {
                                                      _gender = T;
                                                    });
                                                  }
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 0.06 * height,
                                          width: 0.3 * width,
                                          child: const Text(
                                            "DOB",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                        child: Material(
                                          color: editState
                                              ? const Color(0xffffffff)
                                              : Colors.transparent,
                                          child: InkWell(
                                              onTap: editState
                                                  ? () {
                                                      DatePicker.showDatePicker(
                                                          context,
                                                          showTitleActions:
                                                              true,
                                                          minTime: DateTime(
                                                              1900, 1, 1),
                                                          maxTime:
                                                              DateTime.now(),
                                                          onChanged: (date) {
                                                        _dob = date;
                                                      }, onConfirm: (date) {
                                                        _dob = date;
                                                      },
                                                          currentTime: _dob,
                                                          locale:
                                                              LocaleType.en);
                                                    }
                                                  : null,
                                              child: Text(
                                                "${_dob.year.toString()}-${_dob.month.toString()}-${_dob.day.toString()}",
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color(0x8A000000),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.015 * height),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 0.09 * height,
                                          width: 0.3 * width,
                                          child: const Text(
                                            "Address",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                        child: SizedBox(
                                          height: 0.09 * height,
                                          child: TextFormField(
                                            maxLines: 3,
                                            keyboardType:
                                                TextInputType.streetAddress,
                                            controller: _address,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              color: Color(0x8A000000),
                                            ),
                                            decoration: InputDecoration(
                                              enabled: editState,
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              border: const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff263950),
                                                ),
                                              ),
                                              disabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff263950),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  infos(
                                      title: "Nationality",
                                      controller: _nationality,
                                      edit: editState,
                                      keyboardType: TextInputType.text),
                                  infos(
                                      title: "E-mail",
                                      controller: _email,
                                      edit: false,
                                      keyboardType: TextInputType.emailAddress),
                                  infos(
                                      title: "Phone",
                                      controller: _phone,
                                      edit: editState,
                                      keyboardType: TextInputType.phone),
                                  infos(
                                      title: "Blood Group",
                                      controller: _bloodGroup,
                                      edit: editState,
                                      keyboardType: TextInputType.text),
                                  infos(
                                      title: "Weight",
                                      controller: _weight,
                                      edit: editState,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true)),
                                  infos(
                                      title: "Height",
                                      controller: _height,
                                      edit: editState,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true)),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              )
            ]),
          );
        });
  }

  Row infos(
      {required String title,
      required TextEditingController controller,
      required bool edit,
      required keyboardType}) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            height: 0.06 * height,
            width: 0.3 * width,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 17,
                  color: DesignCourseAppTheme.nearlyBlue,
                  fontWeight: FontWeight.bold),
            )),
        Expanded(
          child: SizedBox(
            height: 0.06 * height,
            child: TextFormField(
              keyboardType: keyboardType,
              controller: controller,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0x8A000000),
              ),
              decoration: InputDecoration(
                enabled: edit,
                contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff263950),
                  ),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff263950),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
