import 'package:flutter/src/services/text_input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

import 'Paciente.dart';
import 'global_data.dart';

import 'dart:io';
import '../../../model/global_data.dart';

Future<List<Paciente>> traerPacientes(String value) async {
  debugPrint("Entrando ***********************************\n");

/*    final response1 = await http.get(
        Uri.parse('https://vcsinc.com.ar:8443/patients'),    // Andaaaaa
      // Uri.parse('http://vcsinc.com.ar/patients/Mendoza'),
      // Uri.parse('https://jsonplaceholder.typicode.com:443/albums/1'),
      // Send authorization headers to the backend.
      // headers: {
      //   HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      // },
    );
    debugPrint(response1.body);*/

  var retrievedPatients = <Paciente>[];

  // Si se ejecuta desde Android hay que usar 10.0.2.2:8080 y anda
  // https://stackoverflow.com/questions/55785581/socketexception-os-error-connection-refused-errno-111-in-flutter-using-djan
  Uri url;

  // https://stackoverflow.com/questions/45924474/how-do-you-detect-the-host-platform-from-dart-code

  if (kIsWeb) {
    url = Uri.http('localhost:8080', '/patients/' + value);   // Sin header, anda
    // Sin header anda con vcsinc.com.ar y vcsinc.com.ar:80
    // url = Uri.parse('https://vcsinc.com.ar:8443/patients');        // Anda sin headers y con headers vacíos
    // url = Uri.parse('https://vcsinc.com.ar:8443/patients');        // Anda sin headers y con headers vacíos
    // url = Uri.parse('http://postman-echo.com/headers');   // No anda ni sin headers
  } else {
    if (Platform.isAndroid) {
      url = Uri.http('10.0.2.2:8080', '/patients/' + value);
    } else {
      url = Uri.http('localhost:8080', '/patients');
    }
  }

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
      HttpHeaders.authorizationHeader : "Bearer ${GlobalData.firebaseToken}" // https://jsonplaceholder.typicode.com:443/albums/1' lo digiere bien
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  debugPrint("Después del get ***********************************\n");

  // debugPrint(response.body);

  if (response.statusCode == 200) {

/*      debugPrint(response.body.runtimeType.toString());
      debugPrint(response.body);
      debugPrint("\n");*/

    var jsonResponse =
    convert.jsonDecode(response.body); // as List<Map<String, dynamic>>;

    debugPrint(jsonResponse.runtimeType.toString());

    for (var i = 0; i < jsonResponse.length; i++) {
      retrievedPatients.add(Paciente.fromJson(jsonResponse[i]));
    }

    // for(var i=0;i<jsonResponse.length;i++){
    //   print(Paciente.fromJson(jsonResponse[i]));
    // }
    debugPrint("Intento actualizar pantalla\n");
    // setState(() {
    //   for (var i = 0; i < jsonResponse.length; i++) {
    //     print(Paciente.fromJson(jsonResponse[i]));
    //     allPatients.add(Paciente.fromJson(jsonResponse[i]));
    //   }
    // });
  } else {
    debugPrint('Request failed with status: ${response.statusCode}.');
    throw 'Request failed with status: ${response.statusCode}.';
  }

  debugPrint("Saliendo ***********************************\n");

  return retrievedPatients;
}