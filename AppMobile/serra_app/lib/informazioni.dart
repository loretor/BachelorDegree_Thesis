import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

String text = """La pianta Capsicum frutescens è una pianta erbacea di origine sudamericana appartenente alla famiglia delle Solanacee. Queste piante durante la maturazione producono frutti, i peperoncini. Tali frutti possono assumere colori diversi: da gialli ad arancioni fino a diventare rossi. Le pianta si presenta sotto forma di cespuglio alta da 40 a 80 cm (a seconda della specie) con foglie di colore verde chiaro. I capsaicinoidi sono le sostanze resoponsabili del livello di piccantezza del frutto. E' possibile classificare le diverse varietà di peperoncino proprio con una scala di piccantezza basandosi sui livelli di capsaicinoidi.""";

class informazioni extends StatelessWidget {
  const informazioni({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
        body: Scaffold(
            backgroundColor: Colors.white70,
            body: Center(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                        child: const Text(
                          "Peperoncino",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 182, 36, 36),
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline
                          )
                      )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 12, left: 10, right: 10),
                        child: Image.asset('assets/images/immagine_peperoncino.jpeg')), Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder (
                                borderRadius: BorderRadius.circular(32.0),
                                side: const BorderSide(
                                  width: 5,
                                  color: Colors.green
                                )
                              )
                            ),
                            child: Text(
                              text,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.italic
                              ),
                            )
                          )
                        )
                    ]
                  )
                )
              )
            );
  }
}
