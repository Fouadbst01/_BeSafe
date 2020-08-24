import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test3/advices/home_model.dart';
import 'package:test3/advices/home_view.dart';

class Advicer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeModel(),
        child:Container(
          child: HomeView(),
        )
    );
  }
}