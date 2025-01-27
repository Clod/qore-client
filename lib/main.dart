// Import necessary packages
import 'package:cardio_gut/assets/global_data.dart';
import 'package:cardio_gut/routes/app_router.dart';
import 'package:cardio_gut/util/Connections.dart';
import 'package:cardio_gut/util/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Main function, the entry point of the Flutter application
Future<void> main() async {

  // Configuration for local testing vcsinc.com.ar
  // Defined in /etc/hosts as 192.168.0.102
  debugPrint("********************************************************");
  debugPrint("***** WAIT FOR THE SERVER TO BE AT 192.168.0.102 *****");
  debugPrint("********************************************************");

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Check if running from IDE
  // https://stackoverflow.com/questions/63249638/how-to-use-env-in-flutter-web
  // If IDE does not pass any parameters, assume PROD mode
  if (const String.fromEnvironment("EXECUTION_MODE") == "DEV") {
    // Set execution mode to development
    GlobalData.executionMode = ExecutionMode.dev;
    debugPrint("When running in DEV mode, the Route Guard is not used");
    // The code below might not run anymore
    // If authentication testing is needed for some reason
    // Comment out the line:
    //        authService.authenticated = true;
    // in the route_guard class
  } else {
    // Set execution mode to production
    GlobalData.executionMode = ExecutionMode.prod;
  }

  debugPrint("Running in mode: ${GlobalData.executionMode}");

  // Load URLs from configuration file
  await dotenv.load(fileName: "abracadabra");

  // Retrieve URLs for different environments from .env file
  GlobalData.urlWebDev = dotenv.get("URL_WEB_DEV");
  GlobalData.urlAndDev = dotenv.get("URL_AND_DEV");
  GlobalData.urlProd = dotenv.get("URL_PROD");

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the app and pass in the AppRouter. The app will now depend on the AppRouter
  runApp(
    // Wrap MyApp with ChangeNotifierProvider to provide Connections data
    ChangeNotifierProvider(
      create: (context) => Connections(),
      // Instantiate MyApp
      child: const MyApp(),
    ),
  );
}

// Main application widget, a StatefulWidget to manage its state
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // Flutter stores widgets as a tree, and states are stored along with widgets.
  // To access any member of a state up this tree, use this function to find the MyAppState
  // within this context and then access the authService member variable.
  static MyAppState of(BuildContext context) => context.findAncestorStateOfType<MyAppState>()!;

  // This widget is the root of your application.
  // final AppRouter _appRouter;
  // MyApp(this._appRouter);
  @override
  State<MyApp> createState() => MyAppState();
}

// State class for the MyApp widget
class MyAppState extends State<MyApp> {

  // Instance of AuthService for authentication
  final authProvider = AuthService();
  // Clod: this class is generated from router.dart
  // final _appRouter = AppRouter();

  // Late initialization of AppRouter, passing authProvider
  late final _appRouter = AppRouter(authProvider);

  @override
  Widget build(BuildContext context) {
    // Return MaterialApp.router for routing configuration
    return MaterialApp.router(
      title: "Q-ORE Client", // Application title
      // https://stackoverflow.com/questions/56194440/flutter-default-font-size
      // The resulting font size is (originalSize * fontSizeFactor + fontSizeDelta).
      theme: ThemeData(
        // Apply font scaling factor to the default text theme
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 0.9,
              fontSizeDelta: 0.0,
            ),
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      routerConfig: _appRouter.config(
        // Re-evaluate routes when authProvider notifies listeners
        reevaluateListenable: authProvider,
        //navigatorObservers: () => [AuthGuard()],
        // deepLinkBuilder: (deepLink) {
        //   if (deepLink.path.startsWith('/patient-route')) {
        //     // continue with the platform link
        //     return deepLink;
        //   } else {
        //     //return DeepLink.defaultPath;
        //     // or DeepLink.path('/')
        //     // or DeepLink([HomeRoute()])
        //     return const DeepLink([HomeRoute()]);
        //   }
        // },
      ),
      // routeInformationParser: _appRouter.defaultRouteParser(),
      // routerDelegate: _appRouter.delegate(),
      localizationsDelegates: const [
        // Localization delegates for form builder and material widgets
        FormBuilderLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        // Supported locales
        Locale('en', ''),
        Locale('es', ''),
      ],
    );
  }
}
