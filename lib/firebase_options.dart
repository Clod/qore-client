// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  // Static getter to obtain FirebaseOptions based on the current platform
  static FirebaseOptions get currentPlatform {
    // Check if the app is running on the web
    if (kIsWeb) {
      // Return web FirebaseOptions
      return web;
    }
    // Check the target platform
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      // If the platform is Android
      case TargetPlatform.android:
        // Return android FirebaseOptions
        return android;
      // If the platform is iOS
      case TargetPlatform.iOS:
        // Throw an UnsupportedError indicating that FirebaseOptions are not configured for iOS
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      // If the platform is macOS
      case TargetPlatform.macOS:
        // Throw an UnsupportedError indicating that FirebaseOptions are not configured for macOS
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    // Throw an UnsupportedError if the platform is not supported
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  // Static FirebaseOptions for web platform
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCB4fWrQGF57goA_4wqQnC_utK16eOiPys',
    appId: '1:247160854633:web:3e0486bf6f7179f0ca2af8',
    messagingSenderId: '247160854633',
    projectId: 'cardio-gut',
    authDomain: 'cardio-gut.firebaseapp.com',
    storageBucket: 'cardio-gut.appspot.com',
  );

  // Static FirebaseOptions for android platform
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlcx9_0WATaU2vyB6KhHfVU7CiH5C57jM',
    appId: '1:247160854633:android:09b16c5b7e3583c0ca2af8',
    messagingSenderId: '247160854633',
    projectId: 'cardio-gut',
    storageBucket: 'cardio-gut.appspot.com',
  );
}
