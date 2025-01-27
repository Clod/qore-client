import 'package:logger/logger.dart';

// Class to hold global data
class GlobalData {
  // Firebase token
  static String? firebaseToken;
  // Execution mode (dev or prod)
  static ExecutionMode executionMode = ExecutionMode.prod;
  // URL for web development
  static String? urlWebDev = "http://localhost:8080/patients/";
  // URL for Android development
  static String? urlAndDev = "http://10.0.2.2:8080/patients/";
  // URL for production
  static String? urlProd = "https://vcsinc.com.ar:8443/patients/";

  GlobalData();
}

// Enum for available commands
enum Commands {
  addPatient,
  getPatientsByIdDoc,
  getPatientsByLastName,
  getPatientById,
  updatePatient,
  deletePatient,
  lockPatient,
  rollback, pong,
}

// Enum for execution mode
enum ExecutionMode { dev, prod }

// Logger with stack trace
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    lineLength: 80,
  ),
);

// Logger without stack trace
var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
