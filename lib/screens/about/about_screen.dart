import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen ({Key? key, required this.parametro}) : super(key: key);

  final String parametro;

  @override
  Widget build(BuildContext context) {
    print ("Recibí el parámetro: " + parametro);
    return Scaffold(
        body: Center(
          child: Text(
            'This is our about screen ${parametro}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ));
  }
}