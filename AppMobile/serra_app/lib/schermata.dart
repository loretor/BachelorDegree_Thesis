import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const api = 'https://a9qj196ajf.execute-api.us-east-1.amazonaws.com';

Future<List> getData() async {
  final response = await http.get(Uri.parse(api + '/download'));

  if (response.statusCode == 200) {
    //get the array of values from api/list_races
     return Map<String, dynamic>.from(jsonDecode(response.body))['dati'];
  } else {
    List listavuota = [];
    return listavuota;
  }
}

class schermata extends StatefulWidget {
  const schermata({Key? key}) : super(key: key);

  @override
  State<schermata> createState() => _schermataState();
}

class _schermataState extends State<schermata> {
  late Future<List> dati;
  
  Future<List> refresh() {
    setState(() {
      dati = getData();
    });
    return dati;
  }

  @override
  void initState() {
    dati = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: refresh,
            child: Center(
                child: Container(
                    alignment: Alignment.topCenter,
                    margin:
                        EdgeInsets.only(top: 20, bottom: 20, right: 8, left: 8),
                    //width: double.infinity,
                    child: FutureBuilder<List>(
                      future: dati,
                      builder: (ctx, snapshot){
                        if(snapshot.hasData){
                          final Map<String,dynamic> medie = snapshot.data![0] ;
                          final Map<String,dynamic> stati = snapshot.data![1] ;
                          return SingleChildScrollView(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children:[
                                    Column(
                                      children: medie.entries.map( (entry) => ListTile(
                                          //contentPadding: const EdgeInsets.all(16.0),
                                          title: Text(entry.key),
                                          trailing: Text(entry.value.toString()),
                                          tileColor: Colors.white,
                                      )).toList(),
                                    ),
                                    Column(
                                      children: stati.entries.map( (entry) => ListTile(
                                          //contentPadding: const EdgeInsets.all(16.0),
                                          title: Text(entry.key),
                                          trailing: Text(entry.value.toString()),
                                          tileColor: Colors.blue,
                                      )).toList(),
                                    ), 
                                  ]
                                ),
                          );
                        } 
                        else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                        } 

                        return const CircularProgressIndicator(
                              color: Color(0xFFBB86FC), value: 0.8);
                      }
                      )
                  )
              )
          )
      );
  }
}


