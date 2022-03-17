import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen ({Key? key, required this.parametro}) : super(key: key);

  final String parametro;

  @override
  Widget build(BuildContext context) {
    print ("Recibí el parámetro: " + parametro);
    return Scaffold(
        appBar: AppBar(title: const Text("CardioGut - Ayuda")),
        body: Center(
          child: Text(
            'Acá va el texto de ayuda. ${parametro}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ));
  }
}