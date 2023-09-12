import 'package:flutter/material.dart';

import '../assets/global_data.dart';

informConectionProblems(BuildContext context) {
  var snackBar = SnackBar(
      content: const Text('Error de conexión con el serivdor.'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'OK',
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

informErrorsReportedByServer(String respuesta, BuildContext context) {
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
