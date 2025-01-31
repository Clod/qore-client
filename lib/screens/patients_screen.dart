import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/model/paciente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;
import 'package:provider/provider.dart';
import '../assets/global_data.dart';
import '../main.dart';
// import '../../../model/patientsDAO.dart';
import '../model/patients_dao_ws.dart';
import '../routes/app_router.dart';
import '../util/Connections.dart';

// Future Data
// https://youtu.be/Pp3zoNDGZUI

const int minLastNameLength = 2;

@RoutePage()
class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  var searchIconColor = Colors.redAccent;

  late Future<List<Paciente>>? dataFuture;
  late Connections _connections;

  @override
  void initState() {
    super.initState();
    dataFuture = null; // Si lo pongo en null, usa initialData: allPatients del future builder
    // debugPrint("Recibí el token: ${GlobalData.firebaseToken}");

    // This callback will get called AFTER the Widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connections = Provider.of<Connections>(context, listen: false);

      // _connections.transceiver = Transceiver('wss://vcsinc.com.ar:8080', () {
      //_connections.transceiver = Transceiver('wss://grasso.net.ar:8080', () {
      // _connections.transceiver = Transceiver('ws://127.0.0.1:8080', () {
      // _connections.transceiver = Transceiver('ws://192.168.0.102:8080', () {
      _connections.transceiver = Transceiver(GlobalData.serverUrl!, () {
        // If the server is down, infor and go back to Home
        debugPrint("No hay conexión con el servidor");
        final snackBar = SnackBar(
          duration: const Duration(seconds: 3600),
          content: const Text(
              "No hay conexión con el servidor. Reintente en unos minutos\nSi el problema persiste reporte el problema al servicio técnico."),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              //ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        FirebaseAuth.instance.signOut();
        // Le "aviso" a route_guard
        //MyApp.of(context).authProvider.authenticated = false;
        // Instead, I could send to home.
        AutoRouter.of(context).pushAndPopUntil(const HomeRoute(), predicate: (HomeRoute) => true);
      }, (){});
    });
  }

  String optBuscar = 'Apellido';
  var dropDownBuscar = ['Apellido', 'Documento'];

  TextEditingController datoBusqueda = TextEditingController();

  var patientsDAO = PatientsDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              debugPrint("Después de invalidar authenticated");
              //AutoRouter.of(context).push(const HomeRoute());
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
          const SizedBox(height: 20.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
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
                    searchIconColor = (value.length < minLastNameLength) ? Colors.redAccent : Colors.greenAccent;
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
                            try {
                              dataFuture = patientsDAO.traerPacientesWS(
                                _connections.transceiver!,
                                datoBusqueda.value.text,
                                optBuscar,
                                informConectionProblems,
                                informErrorsReportedByServer,
                              );
                            } catch (e) {
                              logger.f("*********** Reventó ***********");
                              logger.f(e);
                            }
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
                        dataFuture = patientsDAO.traerPacientesWS(
                          _connections.transceiver!,
                          datoBusqueda.value.text,
                          optBuscar,
                          informConectionProblems,
                          informErrorsReportedByServer,
                        );
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

  informConectionProblems() {
    var snackBar = SnackBar(
        content: const Text('Error de conexión con el serivdor.'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  informErrorsReportedByServer(String respuesta) {
    // Remove curly braces from the string
    String keyValueString = respuesta.replaceAll('{', '').replaceAll('}', '').replaceAll('"', '');

// Split the string into an array of key-value pairs
    List<String> keyValuePairs = keyValueString.split(',');
// Create a new Map<String, dynamic> object
    Map<String, dynamic> resultMap = {};

// Populate the Map with key-value pairs
    for (String keyValue in keyValuePairs) {
      // Split each key-value pair by the colon
      List<String> pair = keyValue.split(':');

      // Trim whitespace from the key and value strings
      String key = pair[0].trim();
      String? value = (pair[1].trim() == 'null' ? null : pair[1].trim());

      // Add the key-value pair to the Map
      resultMap[key] = value;
    }

    final snackBar = SnackBar(
      duration: const Duration(seconds: 5),
      content: Text(resultMap['Message']),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          logger.d("Listo");
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Show the list of all Patients retrieved
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
                ),
              ),
            );
          case ConnectionState.done:
          default:
            if (snapshot.hasError) {
              final error = snapshot.error;
              debugPrint("El servidor devolvió un error: ${error.toString()}");
              String input = error.toString();
              String digits = "";
              RegExp exp = RegExp(r"\d{3}");
              RegExpMatch? match = exp.firstMatch(input);
              if (match != null) {
                digits = match.group(0)!;
                debugPrint(digits); // prints "123"
              }
              return Center(
                child: digits == "403"
                    ? const Text(
                        'Error al recuperar datos. \n Usuario no autorizado. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : const Text(
                        'Error al recuperar datos. \n Por favor reintente. \n Si el problema persiste por favor avise al operador. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Text(
                      'No se encontraron pacientes que cumplan con el criterio de búsqueda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data?[index];
                  return Tooltip(
                    message:
                        "Diagnóstico: ${item!.diag1} \nSexo: ${item.sexo} \nFecha de nacimiento: ${item.fechaNacimiento ?? "No informada"} \n${item.comentarios}",
                    child: ListTile(
                      title: Text(item.id.toString() +
                          ") " +
                          item.nombre +
                          ' ' +
                          item.apellido +
                          " (" +
                          (item.pais ?? "Nac. no informada") +
                          ")"),
                      subtitle: Text('Documento: ${item.documento}'),
                      leading: const Icon(Icons.person),
                      onTap: () async {
                        debugPrint('Hiciste click sobre: ${item.apellido}');
                        // AutoRouter.of(context).push(AboutRouter(parametro: item.apellido)); // Anda!
                        // AutoTabsRouter.of(context).setActiveIndex(1); // Navega pero no le paso parámetros
                        // AutoRouter.of(context).pushNamed("/dashboard/profile"); // Navega!
                        // AutoRouter.of(context).push(ProfileRoute(parametro: "Fruta")); Explota
                        // AutoRouter.of(context).navigate(ProfileRoute(parametro: '${item.apellido}')); Anda!!!
                        // Lockeo el registro

                        // String _respuesta = await lockPatientWS(item, informConectionProblems);
                        // if (_respuesta != "Already Locked") {
                        AutoRouter.of(context).navigate(
                          EditPatientRoute(
                              // parametro: allPatients[index]
                              parametro: item),
                        );
                        // } else {
                        //   debugPrint("Registro loqueado por otro");
                        // }
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    'Ingrese un criterio de búsqueda en el panel de arriba',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
