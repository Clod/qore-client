import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../routes/router.gr.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Home'),
      floatingActionButton: FloatingActionButton(onPressed: () {
        AutoRouter.of(context).push(DashboardRoute());
      }),
    );
  }
}
