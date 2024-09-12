import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screen/TaskEditScreen.dart';
import 'package:todo_list/screen/TaskListScreen.dart';
import 'package:todo_list/screen/splashscreen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),  // Set the home screen
    );
  }
}
