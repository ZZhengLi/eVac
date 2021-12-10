import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:vaccinationapp/firebase/firebase.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName, _email, _password, _phoneNumber;
  late Stream _usersStream;
  bool editState = false;
  var selectItemValue;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    _usersStream = FirebaseFirestore.instance.doc("Users/$uid").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
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
              Container(color: const Color(0xff121421)),
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
                          icon: editState ? Icon(Icons.done) : Icon(Icons.edit),
                          onPressed: () {
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
                            style: TextStyle(color: Colors.grey),
                          )),
                    ],
                  ),
                  Expanded(
                    child: Container(
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
                                      height,
                                      width,
                                      "Name",
                                      "data",
                                      TextEditingController(
                                          text: snapshot.data["displayName"]),
                                      editState),
                                  infos(
                                      height,
                                      width,
                                      "ID Card",
                                      "data",
                                      TextEditingController(text: '初始值'),
                                      editState),
                                  Row(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          height: 0.06 * height,
                                          width: 0.2 * width,
                                          child: const Text(
                                            "Gender",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          )),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: 0.06 * height,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<dynamic>(
                                            dropdownColor:
                                                const Color(0xff263950),
                                            style: const TextStyle(
                                                color: Colors.white),
                                            hint: const Text('Gender',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                )),
                                            value: selectItemValue,
                                            items: <String>[
                                              'Male',
                                              'Female',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (T) {
                                              setState(() {
                                                selectItemValue = T;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  infos(
                                      height,
                                      width,
                                      "Name",
                                      "data",
                                      TextEditingController(text: '初始值'),
                                      editState),
                                  infos(
                                      height,
                                      width,
                                      "Name",
                                      "data",
                                      TextEditingController(text: '初始值'),
                                      editState),
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

  Row infos(double height, double width, String title, String data,
      TextEditingController controller, bool edit) {
    return Row(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            height: 0.06 * height,
            width: 0.2 * width,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            )),
        Expanded(
          child: SizedBox(
            height: 0.06 * height,
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
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
              validator: RequiredValidator(errorText: title + " is required"),
              onSaved: (fullName) => _fullName = fullName!,
              onChanged: (text) {
                controller.text = text;
              },
            ),
          ),
        ),
      ],
    );
  }
}
