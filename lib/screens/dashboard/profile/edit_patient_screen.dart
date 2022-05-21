import 'package:cardio_gut/screens/dashboard/products/patient_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../model/Paciente.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;

class EditPatientScreen extends StatelessWidget {
  const EditPatientScreen({Key? key, required this.parametro})
      : super(key: key);

  final Paciente parametro;

  @override
  Widget build(BuildContext context) {
    debugPrint("Building profile screen de: " + parametro.apellido);
    debugPrint("ObjectKey: ${ObjectKey(parametro).toString()}");

    if (parametro.apellido.isEmpty) {
      return Scaffold(
          appBar: AppBar(
              title: const Text(constants.appDisplayName),
              // https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
              automaticallyImplyLeading: true,
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
          // Agrego UniqueKey() para forzar qe redibuje cada vez que vengo con un paciente distinto
          // Si no, se queda con el primero y no lo cambia más.
          // https://alex.domenici.net/archive/how-to-force-a-widget-to-redraw-in-flutter
          // Uso ObjectKey(parametro) para que redibuje sólo cuando cambia el
          // objeto y no siempre, como hace con UniqueKey()
          body: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                child: const FittedBox(
                  child: Text(
                    'Modificar datos del paciente',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PatientWidget(
                key: ObjectKey(parametro),
                parametro: parametro,
              ),
            ],
          ));
      // body: PatientWidget(key: UniqueKey(), parametro: parametro,));
    }
  }
}
