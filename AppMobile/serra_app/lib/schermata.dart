import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const api = 'https://a9qj196ajf.execute-api.us-east-1.amazonaws.com';

Future<String> getStringa(String riferimento) async {
  final response = await http.get(Uri.parse(api + '/download'));

  if (response.statusCode == 200) {
    //get the array of values from api/list_races
    return jsonDecode(response.body)[riferimento];
  } else {
    return "";
  }
}

class schermata extends StatefulWidget {
  const schermata({Key? key}) : super(key: key);

  @override
  State<schermata> createState() => _schermataState();
}

class _schermataState extends State<schermata> {
  late Future<String> temperatura;
  
  @override
  void initState() {
    temperatura = getStringa("Temperatura");
  }

  @override
  Widget build(BuildContext context) {
    return(
      FutureBuilder<String>(
        future: temperatura,
        builder: (ctx, snapshot){
          if(snapshot.hasData){
            final dato = snapshot.data as String;
            return Text(
              '$dato',
              style: TextStyle(
                color: Colors.white
              )
            );
          }
          else{
            return Center(
              child: CircularProgressIndicator()
            );
          }     
        }
      )
    );
  }
}