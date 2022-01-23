import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../screens/additional.dart';

// ignore: camel_case_types
class sideScr extends StatefulWidget {
  const sideScr({Key? key}) : super(key: key);

  @override
  _sideScrState createState() => _sideScrState();
}

// ignore: camel_case_types
class _sideScrState extends State<sideScr> {
  var _showLan = false;
  var _showCoun = false;

  var languages = ["Spanish", "Hindi", "Italy", "French", "German"];
  // ignore: non_constant_identifier_names
  var language_codes = ["es", "hi", "it", "fr", "de"];
  var countries = [
    "Usa",
    "Singapore",
    "Japan",
    "Russia",
    "Canada",
    "Mexico",
    "Malaysia"
  ];
  // ignore: non_constant_identifier_names
  var countries_codes = ["us", "sg", "jp", "ru", "ca", "mx", "my"];

  void onselection(int index, bool isCountry) {
    String name;
    String counLanName;
    if (isCountry) {
      name = countries_codes[index];
      counLanName = countries[index];
    } else {
      name = language_codes[index];
      counLanName = languages[index];
    }
    Navigator.push(
        //not using push named as we want to pass a single value to the constructor of cadditional
        context,
        MaterialPageRoute(
            builder: (context) => additionalScr(
                  counLanCode: name,
                  isCountry: isCountry,
                  counLanName: counLanName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.new_releases_sharp,
                color: Colors.amber,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Additional Features",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 5,
            thickness: 2,
            color: Colors.white,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showLan = !_showLan;
              });
            },
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "News in other language",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          _showLan
              ? Container(
                  margin: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          onselection(index, false);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              languages[index],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              child: Text("${index + 1}"),
                            ),
                            trailing: const Text(
                              ">",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: languages.length,
                    shrinkWrap: true,
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: () {
              setState(() {
                _showCoun = !_showCoun;
              });
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.place,
                  color: Colors.blue.shade900,
                ),
              ),
              title: const Text(
                "News from other country",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          _showCoun
              ? Container(
                  margin: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          onselection(index, true);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              countries[index],
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              child: Text("${index + 1}"),
                            ),
                            trailing: const Text(
                              ">",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: countries.length,
                    shrinkWrap: true,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
