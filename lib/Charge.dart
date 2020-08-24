import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:test3/App.dart';

class Charge extends StatefulWidget {
  static Model M;
  @override
  _ChargeState createState() => _ChargeState();
}

class _ChargeState extends State<Charge> with TickerProviderStateMixin{
  Animation animation;
  AnimationController animationController;
  Animation animation2;
  AnimationController animationController2;
  int a=1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 2),vsync: this);
    animation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
      parent: animationController,curve: Curves.fastOutSlowIn
    ));
    animationController.forward();
    animationController2 = AnimationController(duration: Duration(seconds: 2),vsync: this);
    animation2 = Tween(begin: 1.0,end: 0.0).animate(CurvedAnimation(
        parent: animationController2,curve: Curves.fastOutSlowIn
    ));
    animationController2.forward();
    loadModel();
  }

  loadModel(){
      PyTorchMobile.loadModel("assets/fmodel.pt").then((value){
        Charge.M =value;
        animationOut();
      });
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Container(
      color: Color.fromRGBO(38, 38, 38, 1),
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: animationController,
            builder: (context,child){
              return Transform(
                transform: Matrix4.translationValues(animation.value*size.width, 0.0, 0.0),
                  child:Stack(
                children: <Widget>[
                  Container(
                    height: 102,
                    width: 102,
                    child:CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(254, 205, 103, 1)),
                    ),
                  ),
                  Image.asset('assets/c.png',height: 100,width: 100,),
                ],
              ));
            },
          ),
          SizedBox(height: 10,),
          AnimatedBuilder(
            animation: animationController2,
            builder: (context,child){
              return Transform(
                transform: Matrix4.translationValues(animation2.value*size.width, 0.0,0.0),
                child:Text('BeSave',style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(254, 205, 103, 1),
                    fontSize: 25
                ),) ,
              );
            },
          ),

        ],
      ),
    );
  }

  animationOut(){
    setState(() {
      animationController = AnimationController(duration: Duration(seconds: 1),vsync: this);
      animation = Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
          parent: animationController,curve: Curves.fastOutSlowIn
      ));
      animationController.forward();

      animationController2 = AnimationController(duration: Duration(seconds: 1),vsync: this);
      animation2 = Tween(begin: 0.0,end: -1.0).animate(CurvedAnimation(
          parent: animationController2,curve: Curves.fastOutSlowIn
      ));
      animationController2.forward();
    });
    Timer(Duration(milliseconds: 500),(){
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => App()),);
      //Navigator.pop(context);
    });
  }
}
