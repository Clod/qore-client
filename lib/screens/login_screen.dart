import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;
import '../main.dart';
import '../assets/global_data.dart';
import '../routes/app_router.dart';

// La pantalla de login la saqué de:
// https://www.tutorialkart.com/flutter/flutter-login-screen/

@RoutePage()
class LoginScreen extends StatelessWidget {
  // By convention, widget constructors only use named arguments.
  // Also by convention, the first argument is key, and the last argument
  // is child, children, or the equivalent.
  // If your class represents an object that will never change after its
  // creation, you can benefit from the use of a constant constructor. You
  // have to make sure that all your class fields are final.
  const LoginScreen({Key? key, required this.onResult})
      : super(key: key);

  // onLoginCallback es una función que tiene un parámetro de tipo bool
  final Function(bool loggedIn) onResult;

  static const String _title = constants.appDisplayName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: MyStatefulWidget(onLoginCallback: onResult),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, required this.onLoginCallback})
      : super(key: key);

  final Function(bool loggedIn) onLoginCallback;

  @override
  State<MyStatefulWidget> createState() =>
      _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  late final Function(bool loggedIn) onLoginCallback;

  // https://docs.flutter.dev/cookbook/forms/validation
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {

    super.initState();
    onLoginCallback = widget.onLoginCallback;

    if (!kReleaseMode) {
      nameController.text = "j.claudio.grasso@gmail.com";
      passwordController.text = "222222";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                constants.appDisplayName,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Ingreso',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Usuario',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su usuario';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su password';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child: const Text('Forgot Password',),
            // ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Entrar'),
                onPressed: () async {
                  debugPrint(nameController.text);
                  debugPrint(passwordController.text);

                  if (_formKey.currentState!.validate()) {
                    User? user;

                    try {
                      UserCredential uc = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: nameController.text,
                              password: passwordController.text);
                      debugPrint("XXXXXXXXX " + uc.user.toString());

                      user = FirebaseAuth.instance.currentUser;

                      // OJO que esto sólo anda para WEB
                      // https://firebase.google.com/docs/auth/admin/verify-id-tokens
                      var token = await user?.getIdToken(false);
                      logger.i("Token: $token");
                      // debugPrint("Token: $token");
                      // Pongo el token en una variable global
                      GlobalData.firebaseToken = token;

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        debugPrint('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        debugPrint('Wrong password provided for that user.');
                      }
                    }

                    if (user != null) {
                      // Change value of auth in authservice (en route_guard.dart)
                      MyApp.of(context).authProvider.authenticated = true;
                      onLoginCallback.call(true);
                    } else {
                      var snackBar = const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Credenciales inválidas"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    // OJO que esto está interceptando la navegación a otra pantalla
                    // Por eso no se ve ninguna instrucción de navegación que indique
                    // a donde tiene que ir después.
                    //AutoRouter.of(context).push(DashboardRoute());
                    AutoRouter.of(context).push(const PatientsRoute());
                  }
                },
              ),
            ),
            Row(
              children: <Widget>[
                const Text('¿No conoce el sistema?'),
                TextButton(
                  child: const Text(
                    'Ayuda',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    debugPrint("Intento ir a about");

                    AutoRouter.of(context)
                        .push(PasswordRecoveryRoute(parametro: "Un parámetro"));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
