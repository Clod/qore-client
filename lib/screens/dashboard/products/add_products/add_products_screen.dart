import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  String? dropdownDiag = null;
  String? dropdownSubDiag = null;

  var diagnosticos = ['Diagnóstico 1', 'Diagnóstico 2', 'Diagnóstico 3'];

  var subDiag = [
    ['Diagnóstico 1A', 'Diagnóstico 1B', 'Diagnóstico 1C', 'Diagnóstico 1D'],
    ['Diagnóstico 2A', 'Diagnóstico 2B', 'Diagnóstico 2C', 'Diagnóstico 2D'],
    ['Diagnóstico 3A', 'Diagnóstico 3B', 'Diagnóstico 3C', 'Diagnóstico 3D']
  ];

  int subDiagIndex = 0;

  bool inhabilitarSubDiag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CardioGut'), actions: <Widget>[
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
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'CardioGut',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Incorporar paciente al sistema',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Apellido(s)',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombres(s)',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // TextButton(
              //   onPressed: () {
              //     //forgot password screen
              //   },
              //   child: const Text('Forgot Password',),
              // ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownDiag,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownDiag = newValue!;
                                  subDiagIndex =
                                      diagnosticos.indexOf(dropdownDiag!);
                                  dropdownSubDiag = subDiag[subDiagIndex][0];
                                  inhabilitarSubDiag = false;
                                });
                              },
                              items: diagnosticos.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: const Text(
                                "Seleccionar diagnóstico",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: inhabilitarSubDiag,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownSubDiag,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(color: Colors.deepPurple),
                                // underline: Container(
                                //   height: 2,
                                //   color: Colors.deepPurpleAccent,
                                // ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownSubDiag = newValue!;
                                  });
                                },
                                items: subDiag[subDiagIndex]
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                hint: const Text(
                                  "Seleccionar subdiagnóstico",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Incorporar'),
                    onPressed: () async {
                      print(
                          "Intento dar de alta al paciente: ${firstNameController.text} ${lastNameController.text}");

                      var algo = diagnosticos.indexOf(dropdownDiag!) + 1;
                      var olgo = subDiag[algo - 1].indexOf(dropdownSubDiag!) + 1;

                      print("Con diagnóstico: $algo - $dropdownDiag");
                      print("y SubDiagnóstico: $olgo - $dropdownSubDiag");
                    },
                  )),
              // Row(
              //   children: <Widget>[
              //     const Text('¿No conoce el sistema?'),
              //     TextButton(
              //       child: const Text(
              //         'Ayuda',
              //         style: TextStyle(fontSize: 20),
              //       ),
              //       onPressed: () {
              //         // //signup screen
              //         // AutoRouter.of(context).push(AboutRouter(parametro: "Un parámetro"));
              //       },
              //     )
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.center,
              // ),
            ],
          )),
    );
  }
}
