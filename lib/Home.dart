
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {

  Color c = Color.fromRGBO(217, 121, 4, 1);
  Color c2 = Color.fromRGBO(217, 121, 4, 1);
  Color c3 = Color.fromRGBO(217, 121, 4, 1);
  bool flag = false;
  bool flag2 = false;
  bool flag3 = false;
  double Hlat;
  double HLog;

  @override
  Future<void> initState(){
    // TODO: implement initState
    super.initState();
    //initPlatformState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 38, 38, 1),
      body: Container(
        color: Color.fromRGBO(38, 38, 38, 1),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'Chose ur Mask',
                style: TextStyle(
                    color: Color.fromRGBO(217, 164, 4, 1),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (flag) {
                              c = Color.fromRGBO(217, 121, 4, 1);
                            } else {
                              c = Color.fromRGBO(191, 69, 57, 1);
                              c3 = c2 = Color.fromRGBO(217, 121, 4, 1);
                            }
                            flag = !flag;
                            flag3 = flag2 = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage('assets/mask.png'),
                                  fit: BoxFit.fill,
                                )),
                              ),
                              Text(
                                'surgical Mask',
                                style: TextStyle(
                                  color: Color.fromRGBO(38, 38, 38, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {

                          setState(() {
                            if (flag2) {
                              print('now here');
                              c2 = Color.fromRGBO(217, 121, 4, 1);
                            } else {
                              c2 = Color.fromRGBO(191, 69, 57, 1);
                              c = c3 = Color.fromRGBO(217, 121, 4, 1);
                            }
                            flag2 = !flag2;
                            flag = flag3 = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: c2,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: AssetImage('assets/mask2.png'),
                                  fit: BoxFit.fill,
                                )),
                              ),
                              Text(
                                'N95 Mask',
                                style: TextStyle(
                                    color: Color.fromRGBO(38, 38, 38, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Montserrat'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print('hello');

                /*Model M = await PyTorchMobile.loadModel("assets/fmodel.pt");
                var image = await ImagePicker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 400.0,
                    maxHeight: 400.0);
                String prediction = await M.getImagePrediction(
                    image, 224, 224, 'assets/labels.csv');
                if (prediction == 'Normal') {
                  setState(() {
                    c = Color.fromRGBO(191, 69, 57, 1);
                    c3 = c2 = Color.fromRGBO(217, 121, 4, 1);
                  });
                } else {
                  setState(() {
                    c2 = Color.fromRGBO(191, 69, 57, 1);
                    c3 = c = Color.fromRGBO(217, 121, 4, 1);
                  });
                }*/

              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                  color: c3,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/dobknow.png'),
                              fit: BoxFit.fill)),
                    ),
                    Text('Dont know',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(38, 38, 38, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat')),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: ()async{

                //startLocationService();
              },
              child: Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color.fromRGBO(217, 164, 4, 1),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  child: Center(
                    child: Text(
                      'Start',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(38, 38, 38, 1),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }



}

