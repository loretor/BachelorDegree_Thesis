import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

import './informazioni.dart';
import './legenda.dart';

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

void ciao(){

}

class schermatainiziale extends StatefulWidget {
  const schermatainiziale({Key? key}) : super(key: key);

  @override
  State<schermatainiziale> createState() => _schermatainizialeState();
}


class _schermatainizialeState extends State<schermatainiziale> {
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
            child: SingleChildScrollView(
              child: Container(
                    alignment: Alignment.topCenter,
                    //margin: EdgeInsets.only(top: 10, bottom: 10, right: 2, left: 2),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/serra.jpg'),
                        fit: BoxFit.cover
                      )
                    ),
                    child: Column(
                      children: [
                        //titolo con Peperoncino e informazioni
                        Container(
                          padding: EdgeInsets.only(bottom: 0, right: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder (
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 17, 78, 18)
                              )
                            )
                          ),
                          margin: const EdgeInsets.only(top: 5, bottom: 10),
                          child: Column(
                            children:[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    const Text(
                                      "Peperoncino",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 22,
                                        color: Color.fromARGB(255, 182, 36, 36)
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 100,
                                    ),
                                    MaterialButton(
                                      minWidth: 3,
                                      child: const Icon(
                                        Icons.info_outlined
                                      ),
                                      onPressed: (){
                                        Navigator.push(
                                          context, //permette di muovermi tra le finestra (è la ->)
                                          MaterialPageRoute(
                                              builder: ((context) => informazioni())));
                                      },
                                    )
                                  ]
                                )
                              ),
                            ]
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration:ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder (
                              borderRadius: BorderRadius.circular(32.0),
                              side: const BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 9, 16, 104)
                              )
                            )
                          ),
                          margin: const EdgeInsets.only(top: 10, bottom: 5, right:70, left:70),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                IconData(
                                  0xf0575, 
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: Colors.yellow
                              ),
                              Text(
                                "08:00",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                "-",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25
                                )
                              ),
                              Icon(
                                IconData(
                                  0xe430, 
                                  fontFamily: 'MaterialIcons'
                                ),
                                color: Color.fromARGB(255, 3, 32, 56)
                              ),
                              Text(
                                "20:00",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              )
                            ]
                          )
                        ),
                        //dati vari
                        Container(
                          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //container di sinistra con umidità suolo
                              Container(
                                width: 160,
                                height: 220,
                                decoration:ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder (
                                      borderRadius: BorderRadius.circular(32.0),
                                      side: const BorderSide(
                                          width: 3,
                                          color: Color.fromARGB(255, 128, 190, 241)
                                      )
                                  )
                                ),
                                padding: EdgeInsets.only(top: 17),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Livello Cisterna",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    const Icon(
                                      Icons.local_drink_sharp,
                                      color: Colors.blue,
                                      size: 100
                                    ),
                                    FutureBuilder<List>(
                                      future: dati,
                                      builder: (ctx, snapshot){
                                        if(snapshot.hasData){
                                          final Map<String,dynamic> medie = snapshot.data![0];
                                          int riempimento_cisterna = medie['Livello acqua'];
                                          return Text(
                                            "$riempimento_cisterna%",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25
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
                                  ]
                                )
                              ),
                              //container di destra con dati vari
                              Container(
                                width: 180,
                                height: 220,
                                margin: EdgeInsets.only(top: 0),
                                padding: EdgeInsets.only(left: 12, right:12, top: 2),
                                decoration:ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder (
                                      borderRadius: BorderRadius.circular(32.0),
                                      side: const BorderSide(
                                          width: 3,
                                          color: Colors.green
                                      )
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Dati Ambientali",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        MaterialButton(
                                          minWidth: 1,
                                          child: const Icon(
                                            Icons.info_outlined,
                                            size: 17
                                          ),
                                          onPressed: (){
                                            Navigator.push(
                                              context, //permette di muovermi tra le finestra (è la ->)
                                              MaterialPageRoute(
                                                  builder: ((context) => legenda())));
                                          },
                                        )
                                      ]
                                    ),
                                    SizedBox(height: 5),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              IconData(
                                                0xee2d, 
                                                fontFamily: 'MaterialIcons'
                                              ),
                                              size: 35
                                            ),
                                            FutureBuilder<List>(
                                                future: dati,
                                                builder: (ctx, snapshot){
                                                  if(snapshot.hasData){
                                                    final Map<String,dynamic> medie = snapshot.data![0];
                                                    String orario = medie['Orario'];
                                                    return Text(
                                                      orario,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25
                                                      ),
                                                    );
                                                  } 
                                                  else if (snapshot.hasError) {
                                                    return Text('${snapshot.error}');
                                                  } 
                                                  return const SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xFFBB86FC), value: 0.8
                                                    )
                                                  );
                                                }
                                              )
                                          ]
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.device_thermostat_outlined,
                                              color: Colors.red,
                                              size: 35
                                            ),
                                            FutureBuilder<List>(
                                                future: dati,
                                                builder: (ctx, snapshot){
                                                  if(snapshot.hasData){
                                                    final Map<String,dynamic> medie = snapshot.data![0];
                                                    int temperatura = medie['Media temperatura aria'];
                                                    return Text(
                                                      "$temperatura°C",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25
                                                      ),
                                                    );
                                                  } 
                                                  else if (snapshot.hasError) {
                                                    return Text('${snapshot.error}');
                                                  } 
                                                  return const SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xFFBB86FC), value: 0.8
                                                    )
                                                  );
                                                    
                                                }
                                              )
                                          ]
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(
                                                  IconData(
                                                    0xe064, fontFamily: 'MaterialIcons'
                                                  ),
                                                  size: 35
                                                ),
                                                Icon(
                                                  Icons.water_drop_outlined,
                                                  color: Colors.blue,
                                                  size: 35
                                                ),
                                              ]
                                            ),
                                            FutureBuilder<List>(
                                                future: dati,
                                                builder: (ctx, snapshot){
                                                  if(snapshot.hasData){
                                                    final Map<String,dynamic> medie = snapshot.data![0];
                                                    int umidita_aria = medie['Media umidita aria'];
                                                    return Text(
                                                      umidita_aria.toString()+"%",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25
                                                      ),
                                                    );
                                                  } 
                                                  else if (snapshot.hasError) {
                                                    return Text('${snapshot.error}');
                                                  } 
                                                  return const SizedBox(
                                                    height: 20.0,
                                                    width: 20.0,
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xFFBB86FC), value: 0.8
                                                    )
                                                  );    
                                                }
                                              )
                                          ]
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(
                                                  IconData(
                                                    0xe2e4, 
                                                    fontFamily: 'MaterialIcons'
                                                  ),
                                                  color: Color.fromARGB(255, 27, 117, 30),
                                                  size: 35
                                                ),
                                                Icon(
                                                  Icons.water_drop_outlined,
                                                  color: Colors.blue,
                                                  size: 35
                                                ),
                                              ]
                                            ),
                                            FutureBuilder<List>(
                                                future: dati,
                                                builder: (ctx, snapshot){
                                                  if(snapshot.hasData){
                                                    final Map<String,dynamic> medie = snapshot.data![0];
                                                    int umidita_suolo = medie['Media umidita suolo'];
                                                    return Text(
                                                      umidita_suolo.toString()+"%",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 25
                                                      ),
                                                    );
                                                  } 
                                                  else if (snapshot.hasError) {
                                                    return Text('${snapshot.error}');
                                                  } 
                                                  return const SizedBox(
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xFFBB86FC), value: 0.8
                                                    ),
                                                    height: 20.0,
                                                    width: 20.0
                                                  );    
                                                }
                                              )
                                          ]
                                        ),
                                      ]
                                    )
                                  ]
                                )
                              )
                            ]
                          )    
                        ),
                        //stato degli attuatori
                        Container(
                          //margin: const EdgeInsets.only(top: 0),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                //width: 180,
                                //height: 220,
                                margin: EdgeInsets.only(left:4, right: 4),
                                padding: EdgeInsets.only(left: 20, right:20, top: 0),
                                decoration:ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder (
                                    borderRadius: BorderRadius.circular(32.0),
                                    side: const BorderSide(
                                      width: 3,
                                      color: Color.fromARGB(255, 135, 102, 141)
                                    )
                                  )
                                ),
                                child: Column(
                                  children:[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Stato Attuatori",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13,
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        MaterialButton(
                                          minWidth: 1,
                                          child: const Icon(
                                            Icons.info_outlined,
                                            size: 17
                                          ),
                                          onPressed: (){
                                            Navigator.push(
                                              context, //permette di muovermi tra le finestra (è la ->)
                                              MaterialPageRoute(
                                                  builder: ((context) => legenda())));
                                          },
                                        )
                                      ]
                                    ),
                                    statoattuatori(dati)
                                  ]
                                )
                              )
                            ]
                          )
                        )
                      ],
                    )
                  )
              )
            )        
      );
  }
}

Widget statoattuatori(Future<List<dynamic>> dati){
  return Container(
    alignment: Alignment.topCenter,
    margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
    //width: double.infinity,
    child: FutureBuilder<List>(
      future: dati,
      builder: (ctx, snapshot){
        if(snapshot.hasData){
          final Map<String,dynamic> stati = snapshot.data![1] ;
          return 
                Column(
                  children: stati.entries.map( (entry){
                    if(entry.value == 1){
                      return ListTile(
                        //contentPadding: const EdgeInsets.all(16.0),
                        title: Text(entry.key),
                        trailing: Container(
                          width:20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          )
                        ),
                        tileColor: Colors.white,
                      );
                    }
                    else{
                      return ListTile(
                        //contentPadding: const EdgeInsets.all(16.0),
                        title: Text(entry.key),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          )
                        ),
                        tileColor: Colors.white,
                      );
                    }
                    }
                  ).toList(),
                );
          } 
          else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } 
          return Container(
            padding: EdgeInsets.all(20),
            child: const SizedBox(
              height: 190.0,
              width: 190.0,
                child: CircularProgressIndicator(
                color: Color(0xFFBB86FC), value: 0.8
              )
            )
          );   
      }
    )
  );
}