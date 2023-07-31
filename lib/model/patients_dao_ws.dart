import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'paciente.dart';
import '../assets/global_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Great MySQL summary
// https://www.interviewbit.com/blog/mysql-commands/

// class TransceiverString {
//   WebSocketChannel? _channel;
//   final StreamController<String> _responseStreamController = StreamController<String>();
//
//   TransceiverString(String url) {
//     _channel = WebSocketChannel.connect(Uri.parse(url));
//     _channel!.stream.listen(_handleResponse);
//   }
//
//   void sendMessage({required Commands command, required String data, List<String>? params}) {
//     final encodedMessage = convert.utf8.encode(data);
//     final length = encodedMessage.length;
//     final header = [command.index, length];
//     final frame = [...header, ...encodedMessage];
//     _channel!.sink.add(frame);
//   }
//
//   Stream<String> get responseStream => _responseStreamController.stream;
//
//   void _handleResponse(dynamic response) {
//     String message = response.toString();
//     _responseStreamController.add(message);
//   }
//
//   void close() {
//     _channel!.sink.close();
//     _responseStreamController.close();
//   }
// }

class Transceiver {
  WebSocketChannel? _channel;
  final StreamController<List<int>> _responseStreamController = StreamController<List<int>>();
  Stream<List<int>> get responseStream => _responseStreamController.stream;

  Transceiver(String url, Function callback) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      _handleResponse,
      onError: (e) {
        logger.f(e);
        // throw Exception("Error en la conexión con el servidor: $e");
        callback();
      },
      onDone: () {
        logger.i("Se cerró la conexión con el servidor");
        // throw Exception("Se cerró la conexión con el servidor");
        callback();
      },
    );
  }

  void sendMessage({required Commands command, required String data, List<String>? params}) {
    try {
      final encodedMessage = convert.utf8.encode(data);
      final length = encodedMessage.length;
      final lengthL = length % 255;
      final lengthH = (length / 255).truncate();
      final header = [command.index, lengthH, lengthL];
      final frame = [...header, ...encodedMessage];
      _channel!.sink.add(frame);
    } catch (e) {
      logger.f(e);
      rethrow;
    }
  }

  void _handleResponse(dynamic data) {
    // String message = response.toString();
    try {
      if (data is String) {
        logger.w('Received string message: $data');
        _responseStreamController.add(utf8.encode(data));
      } else if (data is List<int>) {
        logger.w('Received binary message: $data');
        _responseStreamController.add(data);
      } else {
        logger.d('Received unknown message');
      }
    } catch (e) {
      logger.f(e);
      rethrow;
    }
  }

  void close() {
    _channel!.sink.close();
    _responseStreamController.close();
  }
}

// Retrieve Patients from the database bases on a substring of the Id ddocument or Lastname
Future<List<Paciente>> traerPacientesWS(String value, String optBuscar, Function callback, Function callback2) async {
  logger.d("Entrando ***********************************\n");

  logger.d("optBuscar: $optBuscar");

  List<Paciente> retrievedPatients = <Paciente>[];

  // List of Json objects
  late List<dynamic> jsonReceived;

  // Meto un delay para probar el "progress circle"
  // await Future.delayed(const Duration(seconds: 2)); TODO: descomentar

  logger.d("Antes del get ***********************************\n");

  late Transceiver transceiver;
  String? decodedMessage;

  try {
    transceiver = Transceiver('wss://cauto.com.ar:8000', callback);
    if (optBuscar == 'Apellido') {
      transceiver.sendMessage(command: Commands.getPatientsByLastName, data: value);
    } else {
      transceiver.sendMessage(command: Commands.getPatientsByIdDoc, data: value);
    }

    // Wait for the response asynchronously
    await for (List<int> response in transceiver.responseStream) {
      logger.d('Received response: $response');
      // I receive a comma separated string of integers represented as strings
      //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
      decodedMessage = convert.utf8.decode(response.sublist(3));

      logger.d("JSON: $decodedMessage");

      jsonReceived = convert.jsonDecode(decodedMessage);
      break; // Stop listening after the first response is received
    }
  } catch (e) {
    logger.f(e);
    callback2(decodedMessage);
    rethrow;
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

Future<String> addPatientWS(Paciente patient, Function callback) async {
  logger.d('Envío pedido de alta al servidor ');

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8000', callback);

  transceiver.sendMessage(command: Commands.addPatient, data: patient.toJson().toString());

  late String jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    logger.d('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    logger.d("JSON: " +
        convert.utf8.decode(response.sublist(
          3,
        )));

    jsonReceived = convert.utf8.decode(response.sublist(
      3,
    ));
    break; // Stop listening after the first response is received
  }

  return jsonReceived.toString();
}

Future<String> updatePatientWS(Paciente patient, Function callback) async {
  logger.d('Envío pedido de modificación al servidor ');

  Transceiver transceiver = Transceiver('wss://cauto.com.ar:8000', callback);

  transceiver.sendMessage(command: Commands.updatePatient, data: patient.toJson().toString());

  late String jsonReceived;

  // Wait for the response asynchronously
  await for (List<int> response in transceiver.responseStream) {
    logger.d('Received response: $response');
    // I receive a comma separated string of integers represented as strings
    //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
    logger.d("JSON: " +
        convert.utf8.decode(response.sublist(
          3,
        )));

    jsonReceived = convert.utf8.decode(response.sublist(
      3,
    ));
    break; // Stop listening after the first response is received
  }

  return jsonReceived.toString();
}
