import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/model/Paciente.dart';
import 'package:cardio_gut/model/Pacientes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:cardio_gut/assets/Constants.dart' as constants;

import '../../../main.dart';
import '../../../model/PatientsDAO.dart';
import '../../../routes/router.gr.dart';


// Future Data
// https://youtu.be/Pp3zoNDGZUI

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // List allPatients = damePacientes();
  List<Paciente> allPatients = damePacientes();

  var searchIconColor = Colors.redAccent;

  late Future<List<Paciente>>? dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = null; // Si lo pongo en null, usa initialData: allPatients del future builder
    // debugPrint("Recibí el token: ${GlobalData.firebaseToken}");
  }

  String optBuscar = 'Apellido(s)';
  var dropDownBuscar = ['Apellido(s)', 'Documento'];

  TextEditingController datoBusqueda = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.AppDisplayName),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Salir del sistema',
            onPressed: () {
              // Me delogueo de Firebase
              FirebaseAuth.instance.signOut();
              // Le "aviso" a route_guard
              MyApp.of(context).authService.authenticated = false;
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).push(const AddPatientRoute());
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
            child: searchPanel(),
          ),
          // const Divider(color: Colors.black),
          Expanded(
            child: showPatientsList(),
          ),
        ],
      ),
    );
  }

  InputDecorator searchPanel() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: "Buscar por:",
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: optBuscar,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 10.0),
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        optBuscar = newValue!;
                      },
                    );
                  },
                  items: dropDownBuscar.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: datoBusqueda,
                onChanged: (value) => {
                  setState(() {
                    searchIconColor = (value.length < 3)
                        ? Colors.redAccent
                        : Colors.greenAccent;
                  })
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: 'Apellido(s)',
                ),
                onFieldSubmitted: (value) {
                  searchIconColor == Colors.redAccent
                      ? null
                      : setState(
                          () {
                            dataFuture =
                                traerPacientes(datoBusqueda.value.text);
                          },
                        );
                },
              ),
            ),
          ),
          IconButton(
            // onPressed: () async {
            //   print("Buscar con dato ${datoBusqueda}\n");
            //   dataFuture = traerPacientes();
            // },
            onPressed: () {
              // https://stackoverflow.com/questions/44991968/how-can-i-dismiss-the-on-screen-keyboard
              FocusScope.of(context).requestFocus(FocusNode()); // Escondo el teclado virtual
              searchIconColor == Colors.redAccent
                  ? null
                  : setState(
                      () {
                        dataFuture = traerPacientes(datoBusqueda.value.text);
                      },
                    );
            },
            icon: const Icon(Icons.search),
            color: searchIconColor,
          )
        ],
      ),
    );
  }

  FutureBuilder<List<Paciente>> showPatientsList() {
    return FutureBuilder<List<Paciente>>(
      // https://youtu.be/Pp3zoNDGZUI?t=384 Ver el video para ver como usar initial data.
      // initialData: allPatients, // Lo pone en el campo snapshot.data hasta que se resuelve el FUTURE.
      // future: traerPacientes(),
      future: dataFuture,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // return const CircularProgressIndicator();
            return HeartbeatProgressIndicator(
                child: const Center(
                    child: Icon(
              CupertinoIcons.heart_fill,
              color: Colors.pink,
              size: 60.0,
              semanticLabel: 'Text to announce in accessibility modes',
            )));
          case ConnectionState.done:
          default:
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Text('$error');
            } else if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
                return const Center(
                  child: Text(
                    'No se encontraron pacientes',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data?[index];
                  return ListTile(
                    title: Text(item!.id.toString() +
                        ") " +
                        item.nombre +
                        ' ' +
                        item.apellido +
                        " (" +
                        item.nacionalidad +
                        ")"),
                    subtitle: Text('Documento: ${item.documento}'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      debugPrint('Hiciste click sobre: ${item.apellido}');
                      // AutoRouter.of(context).push(AboutRouter(parametro: item.apellido)); // Anda!
                      // AutoTabsRouter.of(context).setActiveIndex(1); // Navega pero no le paso parámetros
                      // AutoRouter.of(context).pushNamed("/dashboard/profile"); // Navega!
                      // AutoRouter.of(context).push(ProfileRoute(parametro: "Fruta")); Explota
                      // AutoRouter.of(context).navigate(ProfileRoute(parametro: '${item.apellido}')); Anda!!!
                      AutoRouter.of(context).navigate(
                        EditPatientRoute(
                            // parametro: allPatients[index]
                            parametro: item),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Ingrese un criterio de búsqueda\n'
                  'en el panel de arriba',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
              // return const CircularProgressIndicator();
              /*                      return HeartbeatProgressIndicator(child: const Center(child: Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.pink,
                        size: 60.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      )));*/
            }
        }
      },
    );
  }
}
