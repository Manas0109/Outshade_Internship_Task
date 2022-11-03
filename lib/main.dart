// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:task/firstPage.dart';
import 'package:task/user_data.dart';

late Box box;
Future<void> main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('mybox');
  Hive.registerAdapter(UserDataAdapter());
  await Hive.openBox<UserData>('users_data');

  runApp(Myapp());
}

@override
void dispose() {
  Hive.close();
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/" : (context) => firstPage()
      },
    );
  }
}