import 'package:cardio_gut/screens/dashboard/products/patient_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;
import '../../../../main.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  // TextEditingController lastNameController = TextEditingController();
  // TextEditingController firstNameController = TextEditingController();
  // TextEditingController documentoController = TextEditingController();
  // TextEditingController dateinput = TextEditingController();
  // TextEditingController observacionesController = TextEditingController();
  //
  // bool? enGestacion = false;
  //
  // String? dropdownDiag;
  // String? dropdownSubDiag;
  // String? dropdownPais;

  @override
  initState() {
    // dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  // var paises = ['Argentina', 'Bolivia', 'Brasil', 'Mongolia'];
  //
  // var diagnosticos = ['Diagnóstico 1', 'Diagnóstico 2', 'Diagnóstico 3'];
  //
  // var subDiag = [
  //   ['Diagnóstico 1A', 'Diagnóstico 1B', 'Diagnóstico 1C', 'Diagnóstico 1D'],
  //   ['Diagnóstico 2A', 'Diagnóstico 2B', 'Diagnóstico 2C', 'Diagnóstico 2D'],
  //   ['Diagnóstico 3A', 'Diagnóstico 3B', 'Diagnóstico 3C', 'Diagnóstico 3D']
  // ];
  //
  // int subDiagIndex = 0;
  //
  // bool inhabilitarSubDiag = true;

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
                MyApp.of(context).authService.authenticated = false;
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
                child: const Text(
                  'Incorporar paciente al sistema',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            PatientWidget(),
          ],
        ),
      ),
    );
  }
}
