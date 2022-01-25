import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:messenger_design/shared/block_obsever.dart';
import 'layout/home_layout.dart';






void main() {
Bloc.observer = MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

      home: HomeLayout () ,
    );
  }

}

