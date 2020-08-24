import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'AdvicesView.dart';
import 'Charge.dart';
import 'CoronaState.dart';
import 'Home.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'Clock.dart';
import 'InfoPage.dart';
import 'dart:ui';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedItemPosition = 0;
  Widget _CurenP;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _CurenP=new ClockP();//new ClockP();
  }

  @override
  Widget build(BuildContext context){

    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: SnakeNavigationBar(
              style: SnakeBarStyle.floating,
              snakeShape: SnakeShape.circle,
              snakeColor: Color.fromRGBO(38, 38, 38, 1),
              backgroundColor: Color.fromRGBO(217, 164, 4, 1),
              showUnselectedLabels: true,
              showSelectedLabels: false,
              currentIndex: _selectedItemPosition,
              onPositionChanged: (index) {
                setState(() {
                  _selectedItemPosition = index;
                  switch (_selectedItemPosition) {
                    case 0:
                      _CurenP=new ClockP();
                      break;
                    case 1:
                      _CurenP=new Numbers();
                      break;
                    case 2:
                      _CurenP=new Advicer();
                      break;
                  }
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('home')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit), title: Text('info')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.whatshot), title: Text('chat')),
              ],
            ),
            body: _CurenP // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}