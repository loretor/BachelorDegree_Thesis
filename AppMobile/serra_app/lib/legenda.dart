import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class legenda extends StatelessWidget {
  const legenda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          centerTitle: true,
        ),
        body: Container(
            //backgroundColor: Colors.white70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/serra.jpg'),
                fit: BoxFit.cover
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 5, bottom: 20, left: 4, right: 4),
                    padding: EdgeInsets.only(bottom: 30),
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
                    child: Column(
                      children: [
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 25, left: 10, right: 10),
                          child: const Text(
                              "Legenda simboli",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                              )
                          )
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child:
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      IconData(
                                        0xf0575, 
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: Colors.yellow
                                    ),
                                    Text(
                                      "-",
                                      style: TextStyle(
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
                                  ]
                                ),
                                const Text(
                                  "Ciclo di attività",
                                  style: TextStyle(
                                    fontSize: 12
                                  )
                                )
                              ]
                            )
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              IconData(
                                0xee2d, 
                                fontFamily: 'MaterialIcons'
                              )
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Orario delle misurazioni",
                                  style: TextStyle(
                                    fontSize: 12
                                  )
                                )
                              ]
                            )
                          ]
                        )
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.device_thermostat_outlined, 
                                color: Colors.red
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Temperatura interna alla serra",
                                    style: TextStyle(
                                      fontSize: 12
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children:const [
                                  Icon(
                                    IconData(
                                      0xe064, 
                                      fontFamily: 'MaterialIcons'
                                    )
                                  ),
                                  Icon(
                                    Icons.water_drop_outlined, 
                                    color: Colors.blue
                                  )
                                ]
                              ),
                              Row(
                                children: const [
                                  Text("Percentuale umidità interna alla serra",
                                    style: TextStyle(
                                      fontSize: 12
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
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
                                  ),
                                  Icon(
                                    Icons.water_drop_outlined, 
                                    color: Colors.blue
                                  )
                                ]
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "Percentuale umidità terreno",
                                    style: TextStyle(
                                      fontSize: 12
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 13,
                              height: 13,
                              decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle
                              ),
                            ),
                            const Text(
                              "Attuatore non attivo",
                              style: TextStyle(
                                fontSize: 12
                              )
                            ),
                          ]
                        )
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 22, left: 10, right: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 13,
                              height: 13,
                              decoration: const BoxDecoration(
                                color: Colors.green, 
                                shape: BoxShape.circle
                              ),
                            ),
                            const Text(
                              "Attuatore attivo",
                              style: TextStyle(
                                fontSize: 12
                              )
                            ),
                          ]
                        )
                    )
                  ]
                )
              )
              ]
            )
          )
        );
  }
}
