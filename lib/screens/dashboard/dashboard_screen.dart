import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("Contruyendo dashboard_screen");
    return const AutoTabsScaffold(
      routes: [
        // const ProductsRoute(),
        // EditPatientRoute(parametro: Paciente(id: 0, nombre: "", apellido: "", fechaNacimiento: "", documento: "", nacionalidad: "", fechaCreacionFicha: "")),
      ],
    );
  }
}