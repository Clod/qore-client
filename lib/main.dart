import 'dart:io';
import 'package:cardio_gut/assets/global_data.dart';
import 'package:cardio_gut/routes/route_guard.dart';
import 'package:cardio_gut/routes/router.gr.dart';
import 'package:cardio_gut/util/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Me fijo si estoy corriendo desde el IDE
  // https://stackoverflow.com/questions/63249638/how-to-use-env-in-flutter-web
  // Si el IDE no le pasa ningún parámetro asumo que es PROD
  if (const String.fromEnvironment("EXECUTION_MODE") == "DEV") {
    GlobalData.executionMode = ExecutionMode.DEV;
  } else {
    GlobalData.executionMode = ExecutionMode.PROD;
  }

  debugPrint ("Ejecutando en modo: ${GlobalData.executionMode}");

  // Ahora cargo las URLs del archivo de configuración
  await dotenv.load(fileName: "abracadabra");

  GlobalData.URL_WEB_DEV=dotenv.get("URL_WEB_DEV");
  GlobalData.URL_AND_DEV=dotenv.get("URL_AND_DEV");;
  GlobalData.URL_PROD=dotenv.get("URL_PROD");;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  // Flutter stores the widgets as a tree, and the states are stored along
  // with the widgets. If we want to access any member of a state up this
  // tree, we can use this function to first find MyAppState within this
  // context, and then access the authService member variable.
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final authService = AuthService();
  // Clod: esta clase se genera a partir de router.dart
  // final _appRouter = AppRouter();
  late final _appRouter = AppRouter(
    routeGuard: RouteGuard(authService),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}
