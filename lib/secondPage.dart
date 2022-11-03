import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/main.dart';

class secondPage extends StatelessWidget {
  // secondPage({Key? key, int? text}) : super(key: key);
  secondPage(int text, {Key? key}) : super(key: key) {
    var box = Hive.box('mybox');
    var res = box.get(text);
    name = res['name'];
    age = res['age'];
    gender = res['gender'];
  }

  late String name;
  late int age;
  late String gender;

  // var _box = Hive.box('mybox');
  // late String name;
  // late var age;
  // late String gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Name: $name"),
            Text("Age: $age"),
            Text("Gender: $gender"),
            
          ],
        ),
      ),
    );
  }
}