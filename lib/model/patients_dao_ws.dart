import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'paciente.dart';
import '../assets/global_data.dart';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';


// Great MySQL summary
// https://www.interviewbit.com/blog/mysql-commands/

class TransceiverString {
  WebSocketChannel? _channel;
  final StreamController<String> _responseStreamController = StreamController<String>();

  TransceiverString(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(_handleResponse);
  }

  void sendMessage({required Commands command, required String data, List<String>? params}) {
    final encodedMessage = convert.utf8.encode(data);
    final length = encodedMessage.length;
    final header = [command.index, length];
    final frame = [...header, ...encodedMessage];
    _channel!.sink.add(frame);
  }

  Stream<String> get responseStream => _responseStreamController.stream;

  void _handleResponse(dynamic response) {
    String message = response.toString();
    _responseStreamController.add(message);
  }

  void close() {
    _channel!.sink.close();
    _responseStreamController.close();
  }
}

class Transceiver {
  WebSocketChannel? _channel;
  final StreamController<List<int>> _responseStreamController = StreamController<List<int>>();

  Transceiver(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(_handleResponse);
  }

  void sendMessage({required Commands command, required String data, List<String>? params}) {
    final encodedMessage = convert.utf8.encode(data);
    final length = encodedMessage.length;
    final lengthL = length % 255;
    final lengthH = (length / 255).truncate();
    final header = [command.index, lengthH, lengthL];
    final frame = [...header, ...encodedMessage];
    _channel!.sink.add(frame);
  }

  Stream<List<int>> get responseStream => _responseStreamController.stream;

  void _handleResponse(dynamic data) {
    // String message = response.toString();
    if (data is String) {
      logger.w('Received string message: $data');
      _responseStreamController.add(utf8.encode(data));
    } else if (data is List<int>) {
      logger.w('Received binary message: $data');
      _responseStreamController.add(data);
    } else {
      logger.d('Received unknown message');
    }
  }

  void close() {
    _channel!.sink.close();
    _responseStreamController.close();
  }
}

// Retrieve Patients from the database bases on a substring of the Id ddocument or Lastname
Future<List<Paciente>> traerPacientesWS(String value, String optBuscar) async {

  logger.d("Entrando ***********************************\n");

  late final channel;

  // try {
  //   channel = WebSocketChannel.connect(
  //     Uri.parse('wss://cauto.com.ar:8080'),
  //   );
  // } catch (e) {
  //   logger.d(e.toString());
  // }

  logger.d("optBuscar: $optBuscar");

  List<Paciente> retrievedPatients = <Paciente>[];

  // Meto un delay para probar el "progress circle"
  // await Future.delayed(const Duration(seconds: 2)); TODO: descomentar

  logger.d("Antes del get ***********************************\n");

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8080');

  if (optBuscar == 'Apellido') {
    transceiver.sendMessage(command: Commands.getPatientsByLastName, data: value);
  } else {
    transceiver.sendMessage(command: Commands.getPatientsByIdDoc, data: value);
  }

  // List of Json objects
  late List<dynamic> jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    logger.d('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    logger.d("JSON: " + convert.utf8.decode(response.sublist(3,)));

    jsonReceived = convert.jsonDecode(convert.utf8.decode(response.sublist(3,)));
    break; // Stop listening after the first response is received
  }

  logger.d("Después del get ***********************************\n");

  logger.d(jsonReceived.toString());

  for (var i = 0; i < jsonReceived.length; i++) {
    retrievedPatients.add(Paciente.fromJson(jsonReceived[i]));
  }

  // logger.d("Me respondió ${response.toString()}");

  logger.d("Saliendo ***********************************\n");

  return retrievedPatients;
}

Future<String> addPatientWS(Paciente patient) async {

  logger.d('Envío pedido de alta al servidor ');

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8080');

  transceiver.sendMessage(command: Commands.addPatient, data: patient.toJson().toString());

  late String jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    logger.d('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    logger.d("JSON: " + convert.utf8.decode(response.sublist(3,)));

    jsonReceived = convert.utf8.decode(response.sublist(3,));
    break; // Stop listening after the first response is received
  }

  return jsonReceived.toString();
}

Future<String> updatePatientWS(Paciente patient) async {

  logger.d('Envío pedido de modificación al servidor ');

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8080');

  transceiver.sendMessage(command: Commands.updatePatient, data: patient.toJson().toString());

  late String jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    logger.d('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    logger.d("JSON: " + convert.utf8.decode(response.sublist(3,)));

    jsonReceived = convert.utf8.decode(response.sublist(3,));
    break; // Stop listening after the first response is received
  }

  return jsonReceived.toString();
}
