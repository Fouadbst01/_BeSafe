import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Charge.dart';
import 'FileManager.dart';

class ClockP extends StatefulWidget {
  @override
  _ClockPState createState() => _ClockPState();
}

class _ClockPState extends State<ClockP> with WidgetsBindingObserver {
  static double per = 1.0;

  final int helloAlarmID = 0;
  int value;
  var displayt;
  static const String _isolateName = 'LocatorIsolate';
  SharedPreferences prefs;

  ReceivePort port = ReceivePort();

  bool mask = false;
  bool manuel = false;
  bool onetime = true;
  bool showshoser = false;
  bool addmask = false;
  String assetM = "";
  bool globShow = true;
  bool firstcal;

  Color C = Color.fromRGBO(38, 38, 38, 1);
  Color C1 = Color.fromRGBO(38, 38, 38, 1);

  @override
  void dispose() {
    saveState();
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    if (AppLifecycleState.resumed != state) {
      saveState();
    }
    super.didChangeAppLifecycleState(state);
  }

  saveState() {
    prefs.setBool("addmask", addmask);
    if (addmask) {
      prefs.setString("assetM", assetM);
    }
    prefs.setBool("mask", mask);
    prefs.setBool("manuel", manuel);
    prefs.setBool("onetime", onetime);
    prefs.setBool("showshoser", showshoser);
    prefs.setBool("globShow", globShow);
    //prefs.setInt("value", value);
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();
    init();
    initPlatformState2();
    super.initState();
  }

  Future<void> updateUI(int data) async {
    if (data == 5) {
      mask = false;
      onetime?print(' '):ShowNotClean();
      onetime = true;
      setState(() {
      manuel = false;
      });
    }
    if (onetime && !mask && data == 10) {
      onetime = false;
      shownotification();
    }
    if (mask && manuel) {
      await FileManager().Dincrement(1);
      final log = await FileManager().readCounter();
      setState(() {
        value = log;
        if(log<=0){
          reset();
          ShowNotifed();
          BackgroundLocator.unRegisterLocationUpdate();
        }
        per = per - 0.000068;
      });
    }
  }

  reset(){
    globShow = true;
    mask = false;
    manuel = false;
    onetime = true;
    showshoser = false;
    addmask = false;
    value = null;
    per = 1.0;
    C = C1 = Color.fromRGBO(38, 38, 38, 1);
    saveState();
  }

  static void callback(LocationDto locationDto) async {
    double lati = await FileManager().readLoc2(0);
    double long = await FileManager().readLoc2(1);
    if (calculateDistance(
            locationDto.latitude, locationDto.longitude, lati, long) >
        80) {
      final SendPort send =
          IsolateNameServer.lookupPortByName('LocatorIsolate');
      send?.send(10);
    } else {
      final SendPort send =
          IsolateNameServer.lookupPortByName('LocatorIsolate');
      send?.send(5);
    }
  }

  Future<void> initPlatformState() async {
    await SharedPreferences.getInstance().then((value2) => {
          setState(() {
            prefs = value2;
            addmask = prefs.getBool("addmask") == null
                ? addmask
                : prefs.getBool("addmask");
            assetM = addmask ? prefs.getString("assetM") : "";
            mask = prefs.getBool("mask") == null ? mask : prefs.getBool("mask");
            manuel = prefs.getBool("manuel") == null
                ? manuel
                : prefs.getBool("manuel");
            onetime = prefs.getBool("onetime") == null
                ? onetime
                : prefs.getBool("onetime");
            showshoser = prefs.getBool("showshoser") == null
                ? showshoser
                : prefs.getBool("showshoser");
            globShow = prefs.getBool("globShow") == null
                ? showshoser
                : prefs.getBool("globShow");
            initPlatformState2();
            /*value =
                prefs.getInt("value") == null ? value : prefs.getInt("value");*/
          })
        });
    await BackgroundLocator.initialize();
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  void startLocationService() async {
    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      settings: LocationSettings(
          wakeLockTime: 14400 /*10 jour*/, autoStop: false, interval: 1),
    );
  }

  Future<void> initPlatformState2() async {
    //setState(() async{
      value =addmask?await FileManager().readCounter():null;
    //});
  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future init() async {
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            AndroidInitializationSettings('@mipmap/ic_launcher'),
            IOSInitializationSettings()),
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String p) {
    if(p != 'maskexpered'){
      mask = true;
      _cancelNotification();
      setState(() {
        manuel = true;
      });
    }
  }

  static Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  ShowNotifed() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0,
        'Alert',
        'you must chage your mask.',
        platformChannelSpecifics,
        payload: 'maskexpered');
  }

  ShowNotClean() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0,
        'Alert',
        'dont forget to clean you hand with soap.',
        platformChannelSpecifics,
        payload: 'maskexpered');
  }

  static shownotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0,
        'Alert',
        'you maste wear your mask to protect your self.\n if you wear it tap on notification to start',
        platformChannelSpecifics,
        payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(38, 38, 38, 1),
        body: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: CircularPercentIndicator(
                      lineWidth: 5,
                      progressColor: Color.fromRGBO(191, 69, 57, 1),
                      radius: 180,
                      percent: per,
                      animation: false,
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Color.fromRGBO(38, 38, 38, 1),
                      center: Text(
                          value == null
                              ? "00:00:00"
                              : _printDuration(Duration(seconds: value)),
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          )),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showshoser = true;
                        });
                      },
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: CircularPercentIndicator(
                          lineWidth: 5,
                          progressColor: Color.fromRGBO(191, 69, 57, 1),
                          radius: 180,
                          percent: per,
                          animation: false,
                          backgroundColor: Color.fromRGBO(38, 38, 38, 1),
                          center: addmask
                              ? Image.asset(
                                  assetM,
                                  height: 100,
                                  width: 100,
                                )
                              : Icon(
                                  Icons.add_circle,
                                  size: 35,
                                  color: Color.fromRGBO(191, 69, 57, 1),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  reset();
                                });
                                BackgroundLocator.unRegisterLocationUpdate();
                                _cancelNotification();
                              },
                              child: Container(
                                width: 60,
                                child: Text(
                                  'Reset',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(217, 164, 4, 1)),
                                ),
                              )),
                          GestureDetector(
                            onTap: () async {
                              firstcal = await FileManager().Filexist();
                              if (!firstcal) {
                                showAlertDialog(context);
                              }
                              if (addmask && firstcal) {

                                setState(() {
                                  showshoser = false;
                                  globShow = false;
                                  manuel = !manuel;

                                  mask = true;
                                });
                                startLocationService();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(217, 164, 4, 1),
                                shape: BoxShape.circle,
                              ),
                              child: manuel
                                  ? Icon(
                                      Icons.pause,
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.play_arrow,
                                      size: 40,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          )
                        ],
                      )),
                ],
              ),
            ),
            globShow && showshoser
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showshoser = false;
                      });
                    },
                    child: Container(
                      color: Color.fromRGBO(38, 38, 38, 0.9),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showshoser = true;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(217, 164, 4, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  width: MediaQuery.of(context).size.width,
                                  height: 330,
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  value = 14400;
                                                  //value = 15;
                                                  addmask = true;
                                                  assetM = "assets/mask.png";
                                                  C = Color.fromRGBO(
                                                      50, 50, 50, 0.8);
                                                  C1 = Color.fromRGBO(
                                                      38, 38, 38, 1);
                                                });
                                                await FileManager().writeCounter(value);
                                              },
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: C,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/mask.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                    Text(
                                                      'churgical mask',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromRGBO(
                                                            191, 191, 191, 1),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  value = 86400;
                                                  addmask = true;
                                                  assetM = "assets/mask2.png";
                                                  C = Color.fromRGBO(
                                                      38, 38, 38, 1);
                                                  C1 = Color.fromRGBO(
                                                      50, 50, 50, 0.8);
                                                });
                                                await FileManager()
                                                    .writeCounter(value);
                                              },
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    color: C1,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image.asset(
                                                      'assets/mask2.png',
                                                      height: 80,
                                                      width: 80,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      'N95 mask',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromRGBO(
                                                            191, 191, 191, 1),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var image =
                                              await ImagePicker.pickImage(
                                                  source: ImageSource.camera,
                                                  maxWidth: 400.0,
                                                  maxHeight: 400.0);
                                          String prediction = await Charge.M
                                              .getImagePrediction(image, 224,
                                                  224, 'assets/labels.csv');
                                          if (prediction == 'Normal') {
                                            //print('normal');
                                            setState(() {
                                              value = 14400;
                                              addmask = true;
                                              assetM = "assets/mask.png";
                                              C = Color.fromRGBO(
                                                  50, 50, 50, 0.8);
                                              C1 =
                                                  Color.fromRGBO(38, 38, 38, 1);
                                            });
                                          } else {
                                            //print('N95');
                                            setState(() {
                                              value = 86400;
                                              addmask = true;
                                              assetM = "assets/mask2.png";
                                              C = Color.fromRGBO(38, 38, 38, 1);
                                              C1 = Color.fromRGBO(
                                                  50, 50, 50, 0.8);
                                            });
                                          }
                                          //
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: Text(
                                            'Click here if you don\'t know.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 30),
                                        child: GestureDetector(
                                          onTap: () {
                                            FileManager().writeCounter(value);
                                            setState(() {
                                              showshoser = false;
                                            });
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    38, 38, 38, 1),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Icons.done_outline,
                                              size: 22,
                                              color: Color.fromRGBO(
                                                  217, 164, 4, 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                      ),
                    ))
                : Container(),
          ],
        ));
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("yeah Im home"),
      onPressed: () async {
        LocationData Hloc = await Location().getLocation();
        FileManager().writeLoc(Hloc);
        Navigator.pop(context);
        setState(() {
          firstcal = false;
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(
          "you must be in your home this app need the location of ur home?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
