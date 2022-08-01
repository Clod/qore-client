import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;

class AboutScreen extends StatelessWidget {
  AboutScreen ({Key? key, required this.parametro}) : super(key: key);

  final String parametro;

  @override
  Widget build(BuildContext context) {
    debugPrint ("Recibí el parámetro: " + parametro);
    return Scaffold(
        appBar: AppBar(title: const Text('${constants.appDisplayName} - Ayuda')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: ()  {
                 FirebaseAuth.instance.sendPasswordResetEmail(email: "j.claudio.grasso@gmail.com");
              }, child: const Text("Apretar")),
              Text(
                'Acá va el texto de ayuda. $parametro',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}