import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'paciente.dart';
import '../assets/global_data.dart';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';


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
    final header = [command.index, length];
    final frame = [...header, ...encodedMessage];
    _channel!.sink.add(frame);
  }

  Stream<List<int>> get responseStream => _responseStreamController.stream;

  void _handleResponse(dynamic response) {
    // String message = response.toString();
    _responseStreamController.add(response);
  }

  void close() {
    _channel!.sink.close();
    _responseStreamController.close();
  }
}

Future<List<Paciente>> traerPacientesWS(String value, String optBuscar) async {
  debugPrint("Entrando ***********************************\n");

  late final channel;

  // try {
  //   channel = WebSocketChannel.connect(
  //     Uri.parse('wss://cauto.com.ar:8080'),
  //   );
  // } catch (e) {
  //   debugPrint(e.toString());
  // }

  debugPrint("optBuscar: $optBuscar");

  List<Paciente> retrievedPatients = <Paciente>[];

  // Meto un delay para probar el "progress circle"
  // await Future.delayed(const Duration(seconds: 2)); TODO: descomentar

  debugPrint("Antes del get ***********************************\n");

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8080');

  if (optBuscar == 'Apellido') {
    transceiver.sendMessage(command: Commands.getPatientsByLastName, data: value);
  }

  // List of Json objects
  late List<dynamic> jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    debugPrint('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    debugPrint("JSON: " + convert.utf8.decode(response.sublist(3,)));

    jsonReceived = convert.jsonDecode(convert.utf8.decode(response.sublist(3,)));
    break; // Stop listening after the first response is received
  }

  debugPrint("Después del get ***********************************\n");

  debugPrint(jsonReceived.toString());

  for (var i = 0; i < jsonReceived.length; i++) {
    retrievedPatients.add(Paciente.fromJson(jsonReceived[i]));
  }

  // debugPrint("Me respondió ${response.toString()}");

  debugPrint("Saliendo ***********************************\n");

  return retrievedPatients;
}


