// Import necessary libraries
import 'dart:convert' as convert; // For JSON conversion
import 'dart:io' show Platform; // For Platform functionalities

import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:http/http.dart' as http; // For HTTP requests

// Define a class to hold the configuration.
class AppConfig {
  final String apiUrl;
  final String environment;
  final Map<String, dynamic> featureFlags;

  AppConfig({
    required this.apiUrl,
    required this.environment,
    this.featureFlags = const {},
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      apiUrl: json['apiUrl'] as String? ?? '', // Provide default if missing
      environment: json['environment'] as String? ?? '', // Provide default if missing
      featureFlags: json['featureFlags'] as Map<String, dynamic>? ?? {}, // Provide default if missing
    );
  }
}

// Main function, entry point of the Dart script
void main(List<String> arguments) async {
  // Example using Google Books API to search for books about http.
  // Documentation: https://developers.google.com/books/docs/overview

  // Example of accessing environment variables in Flutter
  // https://stackoverflow.com/questions/64104688/can-i-use-custom-environment-variables-in-flutter
  // var pindonga = const String.fromEnvironment('JAVA_HOME');
  // print("Pindonga:" + pindonga);

  // Get environment variables
  Map<String, String> envVars = Platform.environment;
  // Print the PATH environment variable for debugging
  debugPrint(envVars['PATH']);

  // Define the URL to fetch patients from a local server
  var url = Uri.http('localhost:8080', '/patients');

  // Send a GET request to the specified URL and wait for the response
  var response = await http.get(url);
  // Check if the request was successful (status code 200)
  if (response.statusCode == 200) {
    // Print the response body for debugging
    debugPrint(response.body);
    // Decode the JSON response body into a Map
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    // Extract the total number of items from the JSON response
    var itemCount = jsonResponse['totalItems'];
    // Print the number of books about http (example from Google Books API comment, might be misleading here)
    debugPrint('Number of books about http: $itemCount.');
  } else {
    // Print an error message if the request failed
    debugPrint('Request failed with status: ${response.statusCode}.');
  }
}
