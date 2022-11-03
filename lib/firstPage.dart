import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:task/secondPage.dart';

class firstPage extends StatefulWidget {
  const firstPage({Key? key}) : super(key: key);

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
List<User> users = [];

  //uri
  var httpsuri = Uri(
    scheme: 'https',
    host: 'manas0109.github.io',
    path: '/Outshade_Internship_Task/Outshade_Data.json',
  );

  Future<List<User>> _data() async {
    var dat = await http.get(httpsuri);

    if (dat.statusCode == 200) {
      var jsonData = json.decode(dat.body.toString());

      for (var u in jsonData) {
        User user = User(u['name'], int.parse(u['id']), u['atype']);
        users.add(user);
      }
    }
    return users;
  }

  //reference our box
  final _mybox = Hive.box('mybox');

  //write data
  writedata(index, age, gender) {
    _mybox.put(users[index].id,
        {"name": users[index].name, "age": age, "gender": gender});
    setState(() {});
  }

  readData(index) {
    var res = _mybox.get(users[index].id);
    print(res.toString());
  }

  delData(index){
    _mybox.delete(users[index].id);
    setState(() {});
  }

  late final Future<List> _future = _data();

  String? dropdownValue;

  void _setDropdownValue(String? value) {
    dropdownValue = value;
    print(dropdownValue);
  }

  Future<void> _showdialog(index) async {
  
    late int age;
    late String gender;
    var genderList = ['M', 'F', 'Others'];
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Center(child: Text("Enter the following data")),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Age: "),
                    SizedBox(
                      width: 90.0,
                      height: 40.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          age = int.parse(text);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Gender: "),
                    SizedBox(
                      width: 100.0,
                      height: 40.0,
                      child: DropdownButton<String>(
                        onChanged: (String? value) {
                          _setDropdownValue(value);
                          setState(() {});
                        },
                        value: dropdownValue ?? genderList.first,
                        items: genderList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(12.0)),
                RaisedButton(
                  onPressed: () {
                    writedata(index, age, dropdownValue);
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => secondPage(users[index].id),
                        ));
                  },
                  child: Text("Submit"),
                  color: Colors.blue,
                )
              ]),
            );
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("User List"),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(users[index].name),
                      onTap: () {
                        if (isSignedIn(index)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    secondPage(users[index].id),
                              ));
                        } else {
                          _showdialog(index);
                        }
                      },
                      trailing: isSignedIn(index)
                          ? TextButton(
                              onPressed: () {
                                readData(index);
                                delData(index);
                                print("Clicked on Sign Out");
                              },
                              child: const Text('Sign Out'),
                            )
                          : TextButton(

                            child: Text('Sign In'),
                            onPressed: (){},),
                    );
                  },
                );
              } else {
                return Container(
                    child: const Center(child: CircularProgressIndicator()));
              }
            }));
  }

  bool isSignedIn(int index) {
    if (_mybox.containsKey(users[index].id)) {
      return true;
    } else {
      return false;
    }
  }
}

class User {
  final String name;
  final int id;
  final String atype;

  User(this.name, this.id, this.atype);
}
