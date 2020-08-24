import 'dart:io';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class FileManager {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> get _localFile2 async {
    final path = await _localPath;
    return File('$path/Location.txt');
  }

  Future<File> get _localFile3 async {
    final path = await _localPath;
    return File('$path/Cases.txt');
  }

  writeCases(int Active,int Recovered,int Death,int RActive,int RRecovered,int RDeath,int a) async {
    String str = Active.toString()+" "+Recovered.toString()+" "+Death.toString()+" "+RActive.toString()+
    " "+RRecovered.toString()+" "+RDeath.toString()+" "+a.toString();
    final file = await _localFile3;
    file.writeAsString('$str');
  }

  writeCases2(String A) async {
    final file = await _localFile3;
    file.writeAsString('\n$A',mode: FileMode.append);
  }

  Future<String> readCase() async {
    final file = await _localFile3 ;
    String contents = await file.readAsString();
    return contents;
  }

  Future<bool> FilexistCases()async{
    final path = await _localPath;
    return File('$path/Cases.txt').exists();
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  writeCounter(int counter) async {
    final file = await _localFile;
    file.writeAsString('$counter');
  }

  Future<String> readLoc() async {
      final file = await _localFile2 ;
      String contents = await file.readAsString();
      return contents;
  }

  Future<double> readLoc2(int a) async {
    final file = await _localFile2 ;
    String contents = await file.readAsString();
    List ls = contents.split(' ');
    return double.parse(ls[a]);
  }

  writeLoc(LocationData L) async {
    String str =L.latitude.toString()+' '+L.longitude.toString();
    final file = await _localFile2 ;
    file.writeAsString('$str');
  }


  Future<bool>Dincrement(int b)async{
    final file = await _localFile;
    int a = await readCounter();
    a=a-b;
    await writeCounter(a);
    return a>0?Future.value(false):Future.value(true);
  }

  Future<bool> Filexist()async{
    final path = await _localPath;
    return File('$path/Location.txt').exists();
  }

}