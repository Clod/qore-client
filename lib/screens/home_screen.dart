import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/screens/patients_screen.dart';
import 'package:flutter/material.dart';

import '../routes/app_router.dart';


@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvendo - Benvenuto - Bemvindo - Welcome'),
      ),
      body: Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          // color: Colors.black,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FittedBox(
                child: Text(
                  'Sólo usuarios autorizados',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    // color: Colors.red,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to DashBoardScreen. If user is not authenticated
          // navigation will be intercepted by login screen
          AutoRouter.of(context).push(
            // const DashboardRoute(),
            const PatientsRoute(),
          );
        },
        child: const Icon(Icons.login),
      ),
    );
  }
}
