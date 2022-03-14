import 'package:cardio_gut/routes/route_guard.dart';
import 'package:cardio_gut/routes/router.gr.dart';
import 'package:cardio_gut/util/auth_service.dart';
import 'package:flutter/material.dart';

void main() {
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
  late final _appRouter = AppRouter(routeGuard: RouteGuard(authService));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate());
  }
}