import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cardio_gut/assets/constants.dart' as constants;

@RoutePage()
class AboutScreen extends StatelessWidget {
  AboutScreen ({Key? key, required this.parametro}) : super(key: key);

  final String parametro;

  @override
  Widget build(BuildContext context) {
    debugPrint ("Recibí el parámetro: " + parametro);
    return Scaffold(
        appBar: AppBar(title: const Text('${constants.appDisplayName} - Ayuda')),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed: ()  {
                 FirebaseAuth.instance.sendPasswordResetEmail(email: "j.claudio.grasso@gmail.com");
                 AutoRouter.of(context).push(const HomeRoute());
              }, child: const Text("Enviar mail reseteo password")),
              Text(
                'Acá va el texto de ayuda. $parametro',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}