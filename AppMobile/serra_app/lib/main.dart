import 'dart:convert';

import './schermatainiziale.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Greenhouse Application"
              ),
              Icon(
                IconData(
                  0xf050a, fontFamily: 'MaterialIcons'
                ),
                color: Color.fromARGB(255, 5, 59, 6)
              )
            ]
          ),
          backgroundColor: Colors.green,
        ),
        body: schermatainiziale());
  }
}
