import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/Paciente.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.parametro}) : super(key: key);

  final Paciente parametro;

  @override
  Widget build(BuildContext context) {
    print("Building profile screen " + parametro.apellido);

    if (parametro.apellido.isEmpty) {
      return Scaffold(
          appBar: AppBar(
              title: const Text(constants.appDisplayName),
              automaticallyImplyLeading:
                  false, // https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
              actions: <Widget>[
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
          body: const Center(
            child: const Text(
              'No hay paciente seleccionado',
              style: TextStyle(fontSize: 24),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
              title: const Text(constants.appDisplayName),
              automaticallyImplyLeading:
                  false, // https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
              actions: <Widget>[
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
              //mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Información del paciente",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Paciente:  ${parametro.nombre} ${parametro.apellido}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Nacionalidad:  ${parametro.nacionalidad}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Documento:  ${parametro.documento}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     // Me delogueo de Firebase
                //     FirebaseAuth.instance.signOut();
                //
                //     // Le "aviso" a route_guard
                //     MyApp.of(context).authService.authenticated = false;
                //   },
                //   child: const Text('Logout'),
                // )
              ],
            ),
          ));
    }
  }
}
