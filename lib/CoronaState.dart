import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:country_pickers/country_pickers.dart';
import 'package:test3/FileManager.dart';

class Numbers extends StatefulWidget {
  @override
  _NumbersState createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  /*Firestore firestore;
  List<String> L=[];*/
  DropdownMenuItem<String> _Selected;
  Map name = {};
  List<DropdownMenuItem<String>> _dropdownm = [];

  Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool flag = false;
  @override
  void dispose() {
    // TODO: implement dispose
    _connectivity=null;
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    checkconnection();
    super.initState();
  }
  checkconnection() {
    _connectivity.checkConnectivity().then((value){
      if(value==ConnectivityResult.mobile||
          value==ConnectivityResult.wifi){
        setState(() {
          flag=true;
        });
      }
    });


    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
          if (event == ConnectivityResult.mobile ||
              event == ConnectivityResult.wifi) {
            setState(() {
              flag = true;
            });
          } else {
            setState(() {
              flag = false;
            });
          }
        });
  }

  getdata() async {
    /* var docs = await Firestore.instance.collection('Contries').getDocuments();
      print(docs.documents.length);
      for(int i=0;i<docs.documents.length;i++){
        L.add(docs.documents[i]["name"]);
    }*/

    String json2 = await rootBundle.loadString('assets/Contries.json');
    List jsonResponse = json.decode(json2);
    print(jsonResponse.length);
    for (int i = 0; i < jsonResponse.length; i++) {
      name[jsonResponse[i]['Name']] = jsonResponse[i]['Code'];
      /*Country _Country =
        CountryPickerUtils.getCountryByIsoCode(jsonResponse[i]['Code']);*/

      _dropdownm.add(DropdownMenuItem(
        value: jsonResponse[i]['Name'],
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/${jsonResponse[i]['Code']}.png',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Text(
              jsonResponse[i]['Name'],
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
      ));
    }
    setState(() {
      selected("World");
    });

    _dropdownm.insert(0, _Selected);
    print(_dropdownm.length);
    /*var output = name.where((element) => !L.contains(element));
    print(output.toList());
    var output2 = L.where((element) => !name.contains(element));
    print(output2.toList());*/
  }

  selected(String value) {
    String im =
        value == "World" ? 'assets/World.png' : 'assets/${name[value]}.png';
    setState(() {
      _Selected = DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Image.asset(
              im,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Text(
              "World",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
      );
    });
  }

  Stream<Map<String, String>> gedData(value) async* {
    var doc =
        await Firestore.instance.collection("Contries").document(value).get();
    print("*" + doc.data["TotaleTest"] + "*");
    Map<String, String> res = {
      "ActiveCases": doc.data["ActiveCases"],
      "NewCases": doc.data["NewCases"],
      "NewDeath": doc.data["NewDeath"],
      "TotalCases": doc.data["TotalCases"],
      "TotalDeath": doc.data["TotalDeath"],
      "TotaleRecovred": doc.data["TotaleRecovred"],
      "TotaleTest": doc.data["TotaleTest"],
    };
    yield res;
  }

  @override
  Widget build(BuildContext context) {
    print("=============================> $flag");
    return Scaffold(
      body: flag
          ? Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(38, 38, 38, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: DropdownButton(
                  value: _Selected.value,
                  items: _dropdownm,
                  onChanged: (value) {
                    setState(() {
                      selected(value);
                    });
                  },
                ),
              ),
              Container(
                  child: StreamBuilder<Map<String, String>>(
                    stream: gedData(_Selected.value),
                    builder: (context, snap) {
                      return snap.connectionState != ConnectionState.waiting
                          ? snap.hasData
                          ? Column(
                        children: <Widget>[
                          Text(
                            "Total Cases:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            snap.data["TotalCases"],
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Active Cases:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            snap.data["ActiveCases"],
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Total Recovered:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            snap.data["TotaleRecovred"],
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Total Deaths:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            (snap.data["TotalDeath"] == " " ||
                                snap.data["TotalDeath"] == ""
                                ? "---"
                                : snap.data["TotalDeath"]),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Totale Test:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            (snap.data["TotaleTest"] == " " ||
                                snap.data["TotaleTest"] == ""
                                ? "---"
                                : snap.data["TotaleTest"]),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "last update:",
                            style: TextStyle(
                                fontSize: 30,
                                color:
                                Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            (snap.data["NewCases"] == " " ||
                                snap.data["NewCases"] == ""
                                ? "+0"
                                : snap.data["NewCases"]) +
                                " active case",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.amber,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            (snap.data["NewDeath"] == " " ||
                                snap.data["NewDeath"] == ""
                                ? "+0"
                                : snap.data["NewDeath"]) +
                                " Death",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      )
                          : Container()
                          : Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor:
                            Color.fromRGBO(217, 164, 4, 1),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(38, 38, 38, 1)),
                          ),
                        ),
                      );
                    },
                  ))
            ],
          ))
          : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(38, 38, 38, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/wifi.png',
              height: 50,
              width: 50,
            ),
            Text(
              'Oups internet problem',
              style: TextStyle(
                  color: Color.fromRGBO(217, 164, 4, 1), fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                checkconnection();
              },
              child: Icon(
                Icons.refresh,
                color: Color.fromRGBO(217, 164, 4, 1),
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
