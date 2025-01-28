import 'package:logger/logger.dart';

// Class to hold global data
class GlobalData {
  // Firebase token
  static String? firebaseToken;
  // Execution mode (dev or prod)
  static ExecutionMode executionMode = ExecutionMode.prod;
  // URL for web development
  static String? serverUrl = "";

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
