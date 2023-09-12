import 'package:logger/logger.dart';

class GlobalData {
  static String? firebaseToken;
  static ExecutionMode executionMode = ExecutionMode.prod;
  static String? urlWebDev = "http://localhost:8080/patients/";
  static String? urlAndDev = "http://10.0.2.2:8080/patients/";
  static String? urlProd = "https://vcsinc.com.ar:8443/patients/";

  GlobalData();
}

enum Commands {
  addPatient,
  getPatientsByIdDoc,
  getPatientsByLastName,
  getPatientById,
  updatePatient,
  deletePatient,
  lockPatient,
  rollback,
}

enum ExecutionMode { dev, prod }

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    lineLength: 80,
  ),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
