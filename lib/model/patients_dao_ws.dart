import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'paciente.dart';
import '../assets/global_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Transceiver {
  WebSocketChannel? _channel;
//  https://stackoverflow.com/questions/73242835/flutter-stream-has-already-been-listened-to
  final StreamController<List<int>> _responseStreamController =
      StreamController<List<int>>.broadcast();
  Stream<List<int>> get responseStream => _responseStreamController.stream;

  // Creo un constructor que recibe la URL del servidor y dos funciones de callback
  // una para cuando se recibe una respuesta del servidor y otra para cuando ocurre un error
  Transceiver(String url, Function callbackDone, Function callbackError) {
    logger.e("Conectando al servidor: $url");
    // Establezco la conexión con el servidor
    _channel = WebSocketChannel.connect(Uri.parse(url));
    // Dejo pendiente la escucha de la respuesta del servidor
    _channel!.stream.listen(
      // Llamado cuando se recibe una respuesta del servidor
      _handleResponse,
      onError: (e) {
        logger.d("Executing on onError");
        logger.f(e);
        _channel?.sink.close();
        callbackError();
      },
      onDone: () {
        logger.d("Executing on onDone");
        logger.d("Se cerró la conexión con el servidor");
        _channel?.sink.close();
        callbackDone();
      },
    );
  }

  void sendMessage(
      {required Commands command, required String data, List<String>? params}) {
    try {
      final fullMessage = prependToken(data);
      final encodedMessage = convert.utf8.encode(fullMessage);
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
    try {
      if (data is String) {
        logger.t('Recibí un mensaje string: $data');
        _responseStreamController.add(utf8.encode(data));
      } else if (data is List<int>) {
        logger.t('Recibí un mensaje binari: $data');
        _responseStreamController.add(data);
      } else {
        logger.w('Recibí un mensaje desconocido');
      }
    } catch (e) {
      logger.f(e);
      rethrow;
    }
  }

  void close() {
    logger.d("Cerrando la conexión con el server");
    _channel!.sink.close();
    _responseStreamController.close();
  }
}

String prependToken(String data) {
  String fullMessage;

  if (GlobalData.executionMode == ExecutionMode.dev) {
    fullMessage = "test_token|" + data;
  } else {
    fullMessage = GlobalData.firebaseToken! + "|" + data;
  }

  return fullMessage;
}

class PatientsDAO {
  void rollbackWS(Transceiver transceiver) {
    transceiver.sendMessage(command: Commands.rollback, data: "");
  }

  Future<Paciente> traerPacienteByIdWS(Transceiver transceiver, int id,
      Function callback, Function callback2) async {
    logger
        .d("Entrando a traerPacientesWS ***********************************\n");

    List<Paciente> retrievedPatients = <Paciente>[];

    // List of Json objects
    late List<dynamic> jsonReceived;

    // Meto un delay para probar el "progress circle"
    await Future.delayed(const Duration(seconds: 2)); // TODO: descomentar

    logger.t("Antes del get ***********************************\n");

    // late Transceiver transceiver;
    String? decodedMessage;

    try {
      transceiver.sendMessage(
          command: Commands.getPatientById, data: id.toString());

      // Wait for the response asynchronously
      await for (List<int> response in transceiver.responseStream) {
        logger.d('Received response: $response');
        // I receive a comma separated string of integers represented as strings
        //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
        decodedMessage = convert.utf8.decode(response.sublist(3));

        logger.d("JSON: $decodedMessage");

        jsonReceived = convert.jsonDecode(decodedMessage);
        logger.t("JsonReceived: ${jsonReceived.toString()}");
        break; // Stop listening after the first response is received
      }
    } catch (e) {
      logger.f(e);
      callback2(decodedMessage);
      rethrow;
    }

    logger.t("Después del get ***********************************\n");

    logger.d(jsonReceived.toString());

    for (var i = 0; i < jsonReceived.length; i++) {
      retrievedPatients.add(Paciente.fromJson(jsonReceived[i]));
    }

    // logger.d("Me respondió ${response.toString()}");

    logger.t("Saliendo ***********************************\n");

    return retrievedPatients[0];
  }

// Retrieve Patients from the database bases on a substring of the Id ddocument or Lastname
  Future<List<Paciente>> traerPacientesWS(Transceiver trans, String value,
      String optBuscar, Function callback, Function callback2) async {
    logger
        .d("Entrando a traerPacientesWS ***********************************\n");

    logger.d("optBuscar: $optBuscar");

    List<Paciente> retrievedPatients = <Paciente>[];

    // List of Json objects
    late List<dynamic> jsonReceived;

    // Meto un delay para probar el "progress circle"
    await Future.delayed(const Duration(seconds: 1));

    logger.d("Antes del get ***********************************\n");

    late Transceiver transceiver;
    String? decodedMessage;

    try {
      transceiver = trans;
      if (optBuscar == 'Apellido') {
        transceiver.sendMessage(
            command: Commands.getPatientsByLastName, data: value);
      } else {
        transceiver.sendMessage(
            command: Commands.getPatientsByIdDoc, data: value);
      }

      // Wait for the response asynchronously
      await for (List<int> response in transceiver.responseStream) {
        logger.d('Received response: $response');
        // I receive a comma separated string of integers represented as strings
        //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
        decodedMessage = convert.utf8.decode(response.sublist(3));

        logger.d("JSON: $decodedMessage");

        jsonReceived = convert.jsonDecode(decodedMessage);
        logger.t("JsonReceived: ${jsonReceived.toString()}");
        break; // Stop listening after the first response is received
      }
    }  catch (e) {
      logger.f(e);
      callback2(decodedMessage);
      rethrow;
    }

    logger.t("Después del get ***********************************\n");

    logger.d(jsonReceived.toString());

    for (var i = 0; i < jsonReceived.length; i++) {
      retrievedPatients.add(Paciente.fromJson(jsonReceived[i]));
    }

    // logger.d("Me respondió ${response.toString()}");

    logger.t("Saliendo ***********************************\n");

    return retrievedPatients;
  }

  Future<String> addPatientWS(
      Transceiver transceiver, Paciente patient, Function callback) async {
    logger.d('Envío pedido de alta al servidor ');

    // Transceiver transceiver = Transceiver('wss://vcsinc.com.ar:8080', callback);
    transceiver.sendMessage(
        command: Commands.addPatient, data: patient.toJson().toString());

    late String jsonReceived;

    // Wait for the response asynchronously
    await for (List<int> response in transceiver.responseStream) {
      logger.d('Received response: $response');
      // I receive a comma separated string of integers represented as strings
      //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
      logger.d("JSON: " + convert.utf8.decode(response.sublist(3)));

      jsonReceived = convert.utf8.decode(response.sublist(3));

      break; // Stop listening after the first response is received
    }

    return jsonReceived.toString();
  }

  Future<String> updatePatientWS(
      Transceiver transceiver, Paciente patient, Function callback) async {
    logger.d('Envío pedido de modificación al servidor ');

    // Transceiver transceiver = Transceiver('wss://vcsinc.com.ar:8080', callback);

    transceiver.sendMessage(
        command: Commands.updatePatient, data: patient.toJson().toString());

    late String jsonReceived;

    // Wait for the response asynchronously
    await for (List<int> response in transceiver.responseStream) {
      logger.d('Received response: $response');
      // I receive a comma separated string of integers represented as strings
      //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();

      logger.d("JSON: " + convert.utf8.decode(response.sublist(3)));

      jsonReceived = convert.utf8.decode(response.sublist(3));
      break; // Stop listening after the first response is received
    }

    return jsonReceived.toString();
  }

  Future<String> updatePatientLockingWS(
      Transceiver transceiver, Paciente patient, Function callback) async {
    logger.d('Envío pedido de modificación al servidor ');

    transceiver.sendMessage(
        command: Commands.updatePatient, data: patient.toJson().toString());

    late String jsonReceived;

    // Wait for the response asynchronously
    await for (List<int> response in transceiver.responseStream) {
      logger.d('Received response: $response');
      // I receive a comma separated string of integers represented as strings
      //final receivedAsList = response.split(',').map((str) => int.parse(str)).toList();
      logger.d("JSON: " + convert.utf8.decode(response.sublist(3)));

      jsonReceived = convert.utf8.decode(response.sublist(3));
      break; // Stop listening after the first response is received
    }

    return jsonReceived.toString();
  }
}
