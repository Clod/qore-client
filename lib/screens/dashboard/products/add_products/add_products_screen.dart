import 'package:cardio_gut/model/PatientsDAO.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
import 'package:cardio_gut/assets/Constants.dart' as constants;
import '../../../../main.dart';

class AddProductsScreen extends StatefulWidget {
  const AddProductsScreen({Key? key}) : super(key: key);

  @override
  State<AddProductsScreen> createState() => _AddProductsScreenState();
}

class _AddProductsScreenState extends State<AddProductsScreen> {
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController documentoController = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController observacionesController = TextEditingController();

  bool? enGestacion = false;

  String? dropdownDiag;
  String? dropdownSubDiag;
  String? dropdownPais;

  @override
  initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  var paises = ['Argentina', 'Bolivia', 'Brasil', 'Mongolia'];

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
      appBar: AppBar(title: const Text(constants.AppDisplayName), actions: <Widget>[
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
              const SizedBox(height: 10),
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
                        flex: 1,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropdownPais,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              // underline: Container(
                              //   height: 2,
                              //   color: Colors.deepPurpleAccent,
                              // ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownPais = newValue!;
                                  // subDiagIndex =
                                  //     diagnosticos.indexOf(dropdownDiag!);
                                  // dropdownSubDiag = subDiag[subDiagIndex][0];
                                  // inhabilitarSubDiag = false;
                                });
                              },
                              items: paises.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              hint: const Text(
                                "País",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          //padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            controller: documentoController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Documento',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        )),
                    child: CheckboxListTile(
                      title: const Text(
                        "Paciente en gestación:",
                        style: TextStyle(fontSize: 15),
                      ),
                      value: enGestacion,
                      onChanged: (newValue) {
                        setState(() {
                          enGestacion = newValue;
                        });
                      },
                      // controlAffinity:
                      //     ListTileControlAffinity.leading, //  <-- leading Checkbox
                    ),
                  )),
                  const SizedBox(width: 20),
                  Expanded(
                      // padding: EdgeInsets.all(15),
                      // height:150,
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        )),
                    child: Center(
                        child: TextField(
                      controller:
                          dateinput, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          border: InputBorder.none,
                          labelText: "Fecha de nacimiento" //label text of field
                          ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime
                              .now(), // Para evitar fechas futuras DateTime(2101)
                        );

                        if (pickedDate != null) {
                          if (kDebugMode) {
                            debugPrint(pickedDate.toString());
                          } //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          if (kDebugMode) {
                            debugPrint(formattedDate);
                          } //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          if (kDebugMode) {
                            debugPrint("Date is not selected");
                          }
                        }
                      },
                    )),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0)),
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
                                "Diagnóstico",
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
                        flex: 1,
                        // https://stackoverflow.com/questions/64425340/how-do-i-disable-any-widget-in-flutter
                        child: AbsorbPointer(
                          absorbing: inhabilitarSubDiag,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                // errorText: "Todo esto es un error",
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownSubDiag,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
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
                                  "Subdiagnóstico",
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
              // const SizedBox(
              //   height: 5,
              // ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 3,
                  maxLines: 5,
                  controller: observacionesController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Observaciones',
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Incorporar'),
                    onPressed: () async {
                      debugPrint(
                          "Intento dar de alta al paciente: ${firstNameController.text} ${lastNameController.text}");

                      var algo = diagnosticos.indexOf(dropdownDiag!) + 1;
                      var olgo =
                          subDiag[algo - 1].indexOf(dropdownSubDiag!) + 1;

                      debugPrint("Con diagnóstico: $algo - $dropdownDiag");
                      debugPrint("y SubDiagnóstico: $olgo - $dropdownSubDiag");
                      debugPrint("En gestación: $enGestacion");

                      addPatient();

                      String mensaje =
                          "Paciente: ${firstNameController.text} ${lastNameController.text} \nDiagnóstico: $dropdownDiag \nSubDiagnóstico: $dropdownSubDiag \nGestación: $enGestacion";
                      // y SubDiagnóstico: $olgo - $dropdownSubDiag
                      // En gestación: $enGestacion";

                      final snackBar = SnackBar(
                        content: Text(mensaje),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
