import 'package:flutter/material.dart';

import '../../main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key, required this.onLoginCallback}) : super(key: key);

  final Function(bool loggedIn) onLoginCallback;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              // Change value of auth in authservice
              MyApp.of(context).authService.authenticated = true;
              onLoginCallback.call(true);
            },
            child:const Text('Tap to login')),
      ),
    );
  }
}