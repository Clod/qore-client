import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/Paciente.dart';

class ProfileScreen extends StatelessWidget {

  ProfileScreen({Key? key, required this.parametro}) : super(key: key);

  Paciente parametro;

  @override
  Widget build(BuildContext context) {

    print ("Building profile screen " + parametro.apellido);

    return Scaffold(
        appBar: AppBar(title: const Text('CardioGut'), actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Salir del sistema',
              onPressed: () {
                // Me delogueo de Firebase
                FirebaseAuth.instance.signOut();
                // Le "aviso" a route_guard
                MyApp.of(context).authService.authenticated = false;
              })
        ]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'This is the profile screen',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Me delogueo de Firebase
                  FirebaseAuth.instance.signOut();

                  // Le "aviso" a route_guard
                  MyApp.of(context).authService.authenticated = false;
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ));
  }
}
