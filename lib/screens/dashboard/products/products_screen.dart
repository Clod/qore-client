import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../routes/router.gr.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

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
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) =>
              Center(child: Text('Paciente #$index'))),
    );
  }
}
