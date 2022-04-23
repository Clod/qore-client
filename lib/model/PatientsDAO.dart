import 'package:flutter/src/services/text_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'Paciente.dart';
import '../assets/global_data.dart';

import 'dart:io';
import '../assets/global_data.dart';

Uri getURI(String value) {
  Uri url;

  if (value.isNotEmpty) value = "/" + value;

  if (GlobalData.executionMode == ExecutionMode.DEV) {
    // https://stackoverflow.com/questions/45924474/how-do-you-detect-the-host-platform-from-dart-code
    if (kIsWeb) {
      url = Uri.parse(GlobalData.URL_WEB_DEV.toString() + value);
    } else {
      if (Platform.isAndroid) {
        // url = Uri.http('10.0.2.2:8080', '/patients/' + value);
        url = Uri.parse(GlobalData.URL_AND_DEV.toString() + value);
      } else {
        url = Uri.parse('http://localhost:8080/patients' + value);
      }
    }
  } else {
    url = Uri.parse(GlobalData.URL_PROD.toString());
  }

  return url;
}

Future<List<Paciente>> traerPacientes(String value) async {
  debugPrint("Entrando ***********************************\n");

  var retrievedPatients = <Paciente>[];

  // Si se ejecuta desde Android hay que usar 10.0.2.2:8080 y anda
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  Uri url = getURI(value);

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

  // debugPrint(response.body);

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

void addPatient() async {
  print('Sending PUT: ');

  Uri url = getURI("");

  var paciente = Paciente(
      id: 9999,
      nombre: "Luigi",
      apellido: "Cadorna",
      fechaNacimiento: "1900-01-28",
      documento: "123456789",
      nacionalidad: "Italia");
  var response;
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
        body: convert.jsonEncode(paciente));
  } catch (e) {
    debugPrint(e.toString());
  }
}
