import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../routes/router.gr.dart';

class LoginScreen extends StatelessWidget {

  // By convention, widget constructors only use named arguments.
  // Also by convention, the first argument is key, and the last argument
  // is child, children, or the equivalent.
  // If your class represents an object that will never change after its
  // creation, you can benefit from the use of a constant constructor. You
  // have to make sure that all your class fields are final.
  const LoginScreen({Key? key, required this.onLoginCallback})
      : super(key: key);

  // onLoginCallback es una función que tiene un parámetro de tipo bool
  final Function(bool loggedIn) onLoginCallback;

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: MyStatefulWidget(onLoginCallback: onLoginCallback),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.onLoginCallback}) : super(key: key);

  final Function(bool loggedIn) onLoginCallback;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState(onLoginCallback);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  _MyStatefulWidgetState(this.onLoginCallback);

  final Function(bool loggedIn) onLoginCallback;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TutorialKart',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    print(nameController.text);
                    print(passwordController.text);

                      User? user;

                      try {
                        UserCredential uc = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                            email: nameController.text,
                            password: passwordController.text);
                        print("XXXXXXXXX" + uc.user.toString());

                        user = FirebaseAuth.instance.currentUser;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }

                      if (user != null) {
                        // Change value of auth in authservice (en route_guard.dart)
                        MyApp.of(context).authService.authenticated = true;
                        onLoginCallback.call(true);
                        print('SIIIIIIIIIIIIIIIIIIIIIII');
                      } else {
                        print('NOOOOOOOOOOOOOOOOOOOOOOO');
                      }

                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'About',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print ("Intento ir a about");
                    //signup screen
                    AutoRouter.of(context).push(AboutRouter(parametro: "Pindonga"));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}
