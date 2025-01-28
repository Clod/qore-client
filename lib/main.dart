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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'firebase_options.dart';

// Define a class to hold the configuration.
class AppConfig {
  final String serverUrl;
  final String environment;
  final Map<String, dynamic> featureFlags;

  AppConfig({
    required this.serverUrl,
    required this.environment,
    this.featureFlags = const {},
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      serverUrl: json['serverUrl'] as String? ?? '', // Provide default if missing
      environment:
          json['environment'] as String? ?? '', // Provide default if missing
      featureFlags: json['featureFlags'] as Map<String, dynamic>? ??
          {}, // Provide default if missing
    );
  }
}

Future<AppConfig?> _fetchConfig() async {
  final configUrl = Uri.parse(
      '/config.json'); // Or your full config URL (e.g., 'https://your-server.com/config.json')

  try {
    final response = await http.get(configUrl);

    if (response.statusCode == 200) {
      logger.i(
          'Configuration file loaded successfully, status code: ${response.statusCode}');
      final jsonResponse = jsonDecode(response.body);
      return AppConfig.fromJson(jsonResponse);
    } else {
      logger.f('Failed to load config, status code: ${response.statusCode}');
      return null; // Indicate failure
    }
  } catch (e) {
    logger.f('Error fetching config: $e');
    return null; // Indicate failure
  }
}

// Main function, the entry point of the Flutter application
Future<void> main() async {

  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig? appConfig; // Declare a variable to hold the config

  try {
    appConfig = await _fetchConfig(); // Fetch config asynchronously
    // Check if server URL is empty
    if (appConfig?.serverUrl == '') {
      logger.f("Server URL is empty. Please check the configuration file.");  
      throw Exception('Server URL is empty');
    }

    GlobalData.serverUrl = appConfig?.serverUrl; // Set server URL

    // Check execution mode
    if (appConfig?.environment == 'dev') {
      // Set execution mode to development
      GlobalData.executionMode = ExecutionMode.dev;
      logger.d("When running in DEV mode, the Route Guard is not used");
      // The code below might not run anymore
    } else {
      // Set execution mode to production
      GlobalData.executionMode = ExecutionMode.prod;
    }
    logger.i(
        'Configuration file loaded successfully: ${appConfig?.serverUrl}, ${appConfig?.environment}');
  } catch (e) {
    logger.f(
        'Failed to load configuration: $e ');
    // If config fails to load, rethrow the error to crash the app
    //rethrow; // Rethrow the error to crash the app
  }

  // Check if running from IDE
  // https://stackoverflow.com/questions/63249638/how-to-use-env-in-flutter-web
  // If IDE does not pass any parameters, assume PROD mode
  // if (const String.fromEnvironment("EXECUTION_MODE") == "DEV") {
  //   // Set execution mode to development
  //   GlobalData.executionMode = ExecutionMode.dev;
  //   debugPrint("When running in DEV mode, the Route Guard is not used");
  //   // The code below might not run anymore
  //   // If authentication testing is needed for some reason
  //   // Comment out the line:
  //   //        authService.authenticated = true;
  //   // in the route_guard class
  // } else {
  //   // Set execution mode to production
  //   GlobalData.executionMode = ExecutionMode.prod;
  // }

  logger.d("Running in mode: ${GlobalData.executionMode}");

  // Load URLs from configuration file
  await dotenv.load(fileName: "abracadabra");

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
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;

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
