import 'dart:convert' as convert;

import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/model/Paciente.dart';
import 'package:cardio_gut/model/Pacientes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../../routes/router.gr.dart';
import 'dart:io';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // List allPatients = damePacientes();
  List<Paciente> allPatients = damePacientes();

  traerPacientes() async {

    print("Entrando ***********************************\n");

    // Si se ejecuta desde Android hay que usar 10.0.2.2:8080 y anda
    // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
    var url;

    if (Platform.isAndroid) {
      url = Uri.http('10.0.2.2:8080', '/patients');
    } else {
      url = Uri.http('localhost:8080', '/patients');
    }



    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body.runtimeType);
      print(response.body);
      print("\n");

      var jsonResponse = convert.jsonDecode(response.body); // as List<Map<String, dynamic>>;

      print(jsonResponse.runtimeType);

      // for(var i=0;i<jsonResponse.length;i++){
      //   print(Paciente.fromJson(jsonResponse[i]));
      // }
      print("Intento actualizar pantalla\n");
      setState(() {
        for(var i=0;i<jsonResponse.length;i++){
          print(Paciente.fromJson(jsonResponse[i]));
          allPatients.add(Paciente.fromJson(jsonResponse[i]));
        }
      });


    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    print("Saliendo ***********************************\n");
  }

  // @override
  // initState() {
  //   //print(http.read(Uri.parse('http://localhost:8080/patients')));
  //   // traerPacientes();
  // }

  String optBuscar = 'Apellido(s)';
  var dropDownBuscar = ['Apellido(s)', 'Documento'];

  TextEditingController datoBusqueda = TextEditingController();

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
        child: const Icon(Icons.person_add),
        tooltip: "Agregar paciente",
      ),
      body: Column(
        children: [
          // Text("Buscar por: ",
          //   style: TextStyle(fontSize: 24),),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: InputDecorator(
              decoration: const InputDecoration(
                  labelText: "Buscar por:",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: optBuscar,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10.0),
                          // underline: Container(
                          //   height: 2,
                          //   color: Colors.deepPurpleAccent,
                          // ),
                          onChanged: (String? newValue) {
                            setState(() {
                              optBuscar = newValue!;
                            });
                          },
                          items: dropDownBuscar
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: datoBusqueda,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          //labelText: 'Apellido(s)',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        print("Buscar con dato ${datoBusqueda}\n");
                        traerPacientes();
                      },
                      icon: Icon(Icons.search))
                ],
              ),
            ),
          ),
          // const Divider(color: Colors.black),
          Expanded(
            child: ListView.builder(
                // itemCount: 100,
                // itemBuilder: (context, index) =>
                //     Center(child: Text('Paciente #$index'))),
                itemCount: allPatients.length,
                itemBuilder: (context, index) {
                  final item = allPatients[index];
                  return ListTile(
                    title: Text(item.nombre +
                        ' ' +
                        item.apellido +
                        " (" +
                        item.nacionalidad +
                        ")"),
                    subtitle: Text('Documento: ${item.documento}'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      print('Hiciste click sobre: ${item.apellido}');
                      // AutoRouter.of(context).push(AboutRouter(parametro: item.apellido)); // Anda!
                      // AutoTabsRouter.of(context).setActiveIndex(1); // Navega pero no le paso parámetros
                      // AutoRouter.of(context).pushNamed("/dashboard/profile"); // Navega!
                      // AutoRouter.of(context).push(ProfileRoute(parametro: "Fruta")); Explota
                      // AutoRouter.of(context).navigate(ProfileRoute(parametro: '${item.apellido}')); Anda!!!
                      AutoRouter.of(context).navigate(
                          ProfileRoute(parametro: allPatients[index]));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
