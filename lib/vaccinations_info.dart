import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaccinationapp/vaccinations_detail.dart';

class Vaccinations_Info extends StatefulWidget {
  Vaccinations_Info({Key? key}) : super(key: key);

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
    var users = FirebaseFirestore.instance.collection("VaccineData").get();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vaccine List"),
        elevation: 0,
        backgroundColor: const Color(0xff121421),
      ),
      backgroundColor: const Color(0xff121421),
      body: SafeArea(
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
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
            ),
            FutureBuilder<QuerySnapshot>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    EasyLoading.dismiss();
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  EasyLoading.dismiss();
                  return Column(
                    children: [
                      ...snapshot.data!.docs
                          .where((element) => element["name"]
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                          .map((data) => InkWell(
                                child: Card(
                                  color: const Color(0xff263950),
                                  child: ListTile(
                                    leading: SvgPicture.asset(
                                        "assets/icons/vaccines.svg",
                                        color: Colors.blue,
                                        height: 50,
                                        semanticsLabel: 'vaccines icon'),
                                    title: Text(data["name"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        )),
                                    subtitle: Text(data["id"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )),
                                    trailing: const Icon(
                                      Icons.navigate_next,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VaccinationsDetail(data: data)));
                                },
                              ))
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
