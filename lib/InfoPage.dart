import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test3/FileManager.dart';
import 'package:web_scraper/web_scraper.dart';

class Infop extends StatefulWidget {
  @override
  _InfopState createState() => _InfopState();
}

class _InfopState extends State<Infop> {
  int TotaleCase;
  int OldTotaleCase;
  int Death;
  int OldDeath;
  int TotalRecovred;
  int Oldrec;
  int AcCase;
  int AcRecov;
  int AcDeath;
  int flag2=0;
  bool flag = true;
  bool flag3 = false;

  @override
  void initState() {
    // TODO: implement initState
    chargdata();
    super.initState();
  }

  getOldD() async {
    String str = await FileManager().readCase();
    List st = str.split(' ');
    if(st.length>3){
      OldTotaleCase = int.parse(st[0]);
      Oldrec = int.parse(st[1]);
      OldDeath = int.parse(st[2]);
      AcCase = int.parse(st[3]);
      AcRecov = int.parse(st[4]);
      AcDeath = int.parse(st[5]);
      flag2=int.parse(st[6]);
    }else{
      AcCase =OldTotaleCase = int.parse(st[0]);
      AcRecov =Oldrec = int.parse(st[1]);
      AcDeath =OldDeath = int.parse(st[2]);
      DateTime now = new DateTime.now();
      String date = new DateFormat('HH').format(now);
      if(int.parse(date)<12)
        flag2=1;
      else
        flag2=2;
      setState(() {
        flag3=true;
      });
    }

  }

  chargdata() async {
    final webScraper = WebScraper('https://www.worldometers.info');
    try {
      if (await webScraper.loadWebPage('/coronavirus/country/morocco/')) {
        List<Map<String, dynamic>> elements =
            webScraper.getElement('div.maincounter-number > span', ['']);
        setState(() {
          TotaleCase =
              int.parse((elements[0]["title"]).toString().replaceAll(',', ''));
          Death =
              int.parse((elements[1]["title"]).toString().replaceAll(',', ''));
          TotalRecovred =
              int.parse((elements[2]["title"]).toString().replaceAll(',', ''));
        });
      }
    } catch (Exeption) {
      setState(() {
        flag = false;
      });
    }

      if(await FileManager().FilexistCases()){
        await getOldD();
        if (flag3 && TotaleCase != AcCase ||
            Death != AcDeath ||
            TotalRecovred != AcRecov){
          if (flag2<2){
            await FileManager().writeCases(OldTotaleCase,Oldrec, OldDeath,
                TotaleCase, TotalRecovred,Death,++flag2);
          }else{
            Oldrec = AcRecov;
            OldDeath = AcDeath;
            OldTotaleCase = AcCase;
            await FileManager().writeCases(
                AcCase, AcRecov, AcDeath, TotaleCase,TotalRecovred,Death,1);
          }
        }
      }
      //else
        //FileManager().writeCases2(TotaleCase, TotalRecovred, Death);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(38, 38, 38, 1),
            child: flag
                ? (TotalRecovred == null || TotaleCase == null || Death == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Color.fromRGBO(217, 164, 4, 1),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(38, 38, 38, 1)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'charging data ....',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(217, 164, 4, 1)),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Coronavirus Cases:",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            TotaleCase.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.amber,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Recovered:",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            TotalRecovred.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "Deaths:",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            Death.toString(),
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                fontWeight: FontWeight.w900),
                          ),
                          flag3 ?Text(
                            "last update:",
                            style: TextStyle(
                                fontSize: 30,
                                color: Color.fromRGBO(191, 191, 191, 1),
                                fontWeight: FontWeight.w400),
                          ):Container(),
                          flag3 ? Text(
                            "+" +
                                (TotaleCase - OldTotaleCase).toString() +
                                " active case",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.amber,
                                fontWeight: FontWeight.w900),
                          ):Container(),
                          flag3 ? Text(
                            "+" +
                                (TotalRecovred - Oldrec).toString() +
                                " recovered",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          ):Container(),
                          flag3 ? Text(
                            "+" + (Death - OldDeath).toString() + " deaths",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.red,
                                fontWeight: FontWeight.w900),
                          ):Container(),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                TotalRecovred = null;
                              });
                              chargdata();
                            },
                            child: Icon(Icons.refresh,size: 30,color: Colors.grey,),
                          )
                        ],
                      )
                : Column(
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
                            color: Color.fromRGBO(217, 164, 4, 1),
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            flag = true;
                            chargdata();
                          });
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Color.fromRGBO(217, 164, 4, 1),
                          size: 30,
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
