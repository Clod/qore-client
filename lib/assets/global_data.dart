class GlobalData {
  static String? firebaseToken;
  static ExecutionMode executionMode = ExecutionMode.PROD;
  static String? URL_WEB_DEV="http://localhost:8080/patients/";
  // static String? URL_WEB_DEV=http://192.168.0.94:8080/patients";
  static String? URL_AND_DEV="http://10.0.2.2:8080/patients/";
  static String? URL_PROD="https://vcsinc.com.ar:8443/patients/";

  GlobalData();
}

enum ExecutionMode {
  DEV,
  PROD
}