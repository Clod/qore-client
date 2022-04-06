import 'package:flutter/material.dart';
import 'package:cardio_gut/assets/Constants.dart' as constants;

class AboutScreen extends StatelessWidget {
  AboutScreen ({Key? key, required this.parametro}) : super(key: key);

  final String parametro;

  @override
  Widget build(BuildContext context) {
    debugPrint ("Recibí el parámetro: " + parametro);
    return Scaffold(
        appBar: AppBar(title: const Text('${constants.AppDisplayName} - Ayuda')),
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