import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/screens/patient_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;
import '../main.dart';

@RoutePage()
class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  
  @override
  initState() {
    // dateinput.text = ""; //set the initial value of text field
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(constants.appDisplayName),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Salir del sistema',
              onPressed: () {
                // Me delogueo de Firebase
                FirebaseAuth.instance.signOut();
                // Le "aviso" a route_guard
                MyApp.of(context).authProvider.authenticated = false;
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: const FittedBox(
                child: Text(
                  'Incorporar paciente al sistema',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const PatientWidget(),
          ],
        ),
      ),
    );
  }
}
