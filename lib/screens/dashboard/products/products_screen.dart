import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/model/Pacientes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../routes/router.gr.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List allPatients = damePacientes();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CardioGut'), actions: <Widget>[
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).push(const AddProductsRoute());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Text("Mostremos algo fijo"),
          Expanded(
            child: ListView.builder(
                // itemCount: 100,
                // itemBuilder: (context, index) =>
                //     Center(child: Text('Paciente #$index'))),
                itemCount: allPatients.length,
                itemBuilder: (context, index) {
                  final item = allPatients[index];
                  return ListTile(
                    title: Text(item.nombre + ' ' + item.apellido),
                    subtitle: Text(item.nacionalidad),
                    onTap: () {
                      print('Hiciste click sobre: ${item.apellido}');
                      // AutoRouter.of(context).push(AboutRouter(parametro: item.apellido)); // Anda!
                      // AutoTabsRouter.of(context).setActiveIndex(1); // Navega pero no le paso parámetros
                      // AutoRouter.of(context).pushNamed("/dashboard/profile"); // Navega!
                      // AutoRouter.of(context).push(ProfileRoute(parametro: "Fruta")); Explota
                      // AutoRouter.of(context).navigate(ProfileRoute(parametro: '${item.apellido}')); Anda!!!
                      AutoRouter.of(context).navigate(ProfileRoute(parametro: allPatients[index]));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
