import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vaccinationapp/vaccinations_detail.dart';
import 'package:vaccinationapp/fitness_app/fitness_app_theme.dart';
import 'package:vaccinationapp/design_course/design_course_app_theme.dart';

class Vaccinations_Info extends StatefulWidget {
  const Vaccinations_Info({Key? key}) : super(key: key);

  @override
  State<Vaccinations_Info> createState() => _Vaccinations_InfoState();
}

class _Vaccinations_InfoState extends State<Vaccinations_Info> {
  late TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vaccineDetail = FirebaseFirestore.instance
        .doc("VaccineDetail/rqVBsoTdgyAN4faYrWLx")
        .collection("DetailsOfVaccine")
        .get();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text("Vaccine List",
            style: TextStyle(
              color: Colors.black,
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        elevation: 0,
        backgroundColor: FitnessAppTheme.background,
      ),
      backgroundColor: FitnessAppTheme.background,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
                margin:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 22),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: DesignCourseAppTheme.nearlyBlue,
                              width: 2.5),
                          borderRadius: BorderRadius.circular(30)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Search",
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController = TextEditingController();
                          setState(() {});
                        },
                      )),
                  onChanged: (v) {
                    setState(() {
                      _searchController = TextEditingController(text: v);
                      _searchController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _searchController.text.length));
                      setState(() {});
                    });
                  },
                )),
            FutureBuilder<QuerySnapshot>(
                future: vaccineDetail,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    EasyLoading.dismiss();
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  EasyLoading.dismiss();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 110,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ...snapshot.data!.docs
                              .where((element) => element["name"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      _searchController.text.toLowerCase()))
                              .map((data) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VaccinationsDetail(
                                                    data: data)));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height: 140,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.white,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                              topRight: Radius.circular(15.0)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.2),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Text(
                                                      data["name"],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              FitnessAppTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 22,
                                                          letterSpacing: -0.1,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlue),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 7),
                                                            child: Text(
                                                              data[
                                                                  "eligible_age"],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FitnessAppTheme
                                                                        .fontName,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Color(
                                                                    0xffb3b3b3),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))))
                        ]),
                  );
                })
          ],
        ),
      ),
    );
  }
}
