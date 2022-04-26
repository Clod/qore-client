import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routes/router.gr.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvendo - Benvenuto - Bemvindo - Welcome'),
      ),
      body: const Center(
        child: Text(
          'Sólo usuarios autorizados',
          textAlign: TextAlign.center,
          style: TextStyle(
            // color: Colors.red,
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).push(
            const DashboardRoute(),
          );
        },
        child: const Icon(Icons.login),
      ),
    );
  }
}
