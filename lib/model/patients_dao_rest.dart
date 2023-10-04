import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'paciente.dart';
import '../assets/global_data.dart';

import 'dart:io';


Uri getURI(String tipoDato, String value) {
  Uri url;
  String parametros = "";

  if (tipoDato.isNotEmpty) parametros = "/" + tipoDato;
  if (value.isNotEmpty) parametros += "/" + value;

  // https://stackoverflow.com/questions/55004302/how-do-you-pass-arguments-from-command-line-to-main-in-flutter-dart
  if (GlobalData.executionMode == ExecutionMode.dev) {
    // https://stackoverflow.com/questions/45924474/how-do-you-detect-the-host-platform-from-dart-code
    if (kIsWeb) {
      url = Uri.parse(GlobalData.urlWebDev.toString() + parametros);
    } else {
      if (Platform.isAndroid) {
        //   static String? URL_AND_DEV="http://10.0.2.2:8080/patients/";
//        url = Uri.parse(GlobalData.URL_AND_DEV.toString() + parametros);
        url = Uri.parse("http://192.168.0.94:8080/patients"+ parametros);
      } else {
        url = Uri.parse('http://localhost:8080/patients' + parametros);
      }
    }
  } else {
    url = Uri.parse(GlobalData.urlProd.toString() + parametros);
    // url = Uri.parse("http://192.168.0.94:8080/patients"+ value);
  }

  return url;
}

Future<List<Paciente>> traerPacientes(String value, String optBuscar) async {
  debugPrint("Entrando ***********************************\n");

  debugPrint("optBuscar: $optBuscar");

  List<Paciente> retrievedPatients = <Paciente>[];

  // Si se ejecuta desde Android hay que usar 10.0.2.2:8080 y anda
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  Uri url = getURI(optBuscar,value);

  debugPrint("Intentando traer pacientes de: " + url.toString());

  // Meto un delay para probar el "progress circle"
  await Future.delayed(const Duration(seconds: 2));

  debugPrint("Antes del get ***********************************\n");

  // EL HOST ACEPTA HEADERS SI SE LOS MANDO CON CURL Y LEE EL TOKEN
  // Await the http get response, then decode the json-formatted response.
  // https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
  var response;

  try {
    // response = await http.get(url,);  // Anda
    response = await http.get(url, headers: {
      // "Access-Control-Allow-Origin": "*",
      // "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalData.firebaseToken}" // https://jsonplaceholder.typicode.com:443/albums/1' lo digiere bien
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  debugPrint("Después del get ***********************************\n");

  debugPrint(response.body);

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body); // as List<Map<String, dynamic>>;

    debugPrint(jsonResponse.runtimeType.toString());

    for (var i = 0; i < jsonResponse.length; i++) {
      retrievedPatients.add(Paciente.fromJson(jsonResponse[i]));
    }

    debugPrint("Intento actualizar pantalla\n");
  } else {
    debugPrint('Request failed with status: ${response.statusCode}.');
    throw 'Request failed with status: ${response.statusCode}.';
  }

  debugPrint("Saliendo ***********************************\n");

  return retrievedPatients;
}

Future<String> addPatient(Paciente patient) async {

  debugPrint('Enviando POST: ');
  Uri url = getURI("","");
  http.Response response;
  String idPaciente = "";
  RegExp exp = RegExp(r'(\{\d+\})');

  try {
    // response = await http.get(url,);  // Anda
    response = await http.post(url,
        headers: {
          // "Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
              "Bearer ${GlobalData.firebaseToken}" // https://jsonplaceholder.typicode.com:443/albums/1' lo digiere bien
        },
        body: convert.jsonEncode(patient));
    debugPrint("Respuesta del servidor:  ${response.statusCode} - ${response.body}");

    // Si el paciente ya existe devuelvo id = -1
    // Horrible pero estoy podrido
    if (response.statusCode == 406 ){
      idPaciente = "-1";
    }
    {
      RegExpMatch? id = exp.firstMatch(response.body);
      idPaciente = id![0].toString();
      debugPrint("Id del paciente creado: " + idPaciente);
    }
  } catch (e) {
    debugPrint("Error en el alta: " + e.toString());
  }
  return idPaciente;
}

Future<String>  updatePatient(Paciente patient) async {
  debugPrint('Enviando PUT: ');

  Uri url = getURI("","");
  String idPaciente = "";
  RegExp exp = RegExp(r'(\{\d+\})');

  http.Response response;
  try {
    response = await http.put(url,
        headers: {
          // "Access-Control-Allow-Origin": "*",
          // "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD"
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader:
          "Bearer ${GlobalData.firebaseToken}" // https://jsonplaceholder.typicode.com:443/albums/1' lo digiere bien
        },
        body: convert.jsonEncode(patient));
    debugPrint("Respuesta del servidor:  ${response.statusCode} - ${response.body}");
    RegExpMatch? id = exp.firstMatch(response.body);
    idPaciente = id![0].toString();
    debugPrint("Id del paciente creado: " + idPaciente);
  } catch (e) {
    debugPrint(e.toString());
  }

  return idPaciente;
}
