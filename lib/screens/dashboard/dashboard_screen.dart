import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/model/Paciente.dart';
import 'package:flutter/material.dart';

import '../../routes/router.gr.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen ({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        const ProductsRoute(),
        ProfileRoute(parametro: Paciente(nombre: "", apellido: "", fechaNacimiento: DateTime.now(), documento: "", nacionalidad: "")),
      ],
      bottomNavigationBuilder: (context, tabsRouter) => BottomNavigationBar(
          onTap: tabsRouter.setActiveIndex,
          currentIndex: tabsRouter.activeIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Pacientes',
              icon: Icon(
                Icons.people,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Paciente',
              icon: Icon(
                Icons.person,
              ),
            ),
          ]),
    );
  }
}