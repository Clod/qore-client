# cardio_gut

La navagación que tiene en cuenta la autenticación la saco de:

https://blog.logrocket.com/implementing-route-guards-flutter-web-apps/
https://github.com/Chinmay-KB/route_guard_example/issues/1

--------------------------------------
Agrego Firebase Auth: https://pub.dev/packages/firebase_auth

1) flutter pub add firebase_core

2) dart pub global activate flutterfire_cli

flutterfire configure

Platform  Firebase App Id
web       1:247160854633:web:3e0486bf6f7179f0ca2af8
android   1:247160854633:android:09b16c5b7e3583c0ca2af8

Learn more about using this file in the FlutterFire documentation:
> https://firebase.flutter.dev/docs/cli

3) flutter pub add firebase_auth

Resolving dependencies...
build_runner 2.1.7 (2.1.8 available)
collection 1.15.0 (1.16.0 available)
+ firebase_auth 0.15.1+1 (3.3.10 available)
+ firebase_auth_platform_interface 1.1.8 (6.2.1 available)
  firebase_core 0.4.2+2 (1.13.1 available)
  firebase_core_platform_interface 1.0.4 (4.2.5 available)
  material_color_utilities 0.1.3 (0.1.4 available)
  path 1.8.0 (1.8.1 available)
  plugin_platform_interface 1.0.3 (2.1.2 available)
  quiver 2.1.5 (3.0.1+1 available)
  source_span 1.8.1 (1.8.2 available)
  test_api 0.4.8 (0.4.9 available)
  vector_math 2.1.1 (2.1.2 available)
  Changed 2 dependencies!
  The plugin `firebase_auth` uses a deprecated version of the Android embedding.
  To avoid unexpected runtime failures, or future build failures, try to see if this plugin supports the Android V2 embedding. Otherwise, consider removing it since a
  future release of Flutter will remove these deprecated APIs.
  If you are plugin author, take a look at the docs for migrating the plugin to the V2 embedding: https://flutter.dev/go/android-plugin-migration.

Corro la app con:

4) flutter run

y corre, pero, evidentemente, todavía no usa auth

firebase_options.dat tiraba una parva de errores que se fueron tocando pubspec.yaml
(inspirado en: https://codewithandrea.com/articles/flutter-firebase-flutterfire-cli/)

firebase_core: ^1.10.6 <- Cambiada la versión
#firebase_auth: ^0.15.1+1 <- Comentado

Ahora intento meter el código en main.dart

Logré inicializar Firebase.

Ahora tengo que configurar Auth. Para el caso de GMail tengo que hacer la 
configuración manual: 

https://firebase.flutter.dev/docs/manual-installation/

Como se me complicó la configuración de la autenticación con GMail opto por validación por
usuario/password.

Saco la pantalla de login de:

https://www.tutorialkart.com/flutter/flutter-login-screen/

--------------------------------
Para subirlo a Firebase Hosting (estoy convencido de que ya lo había hecho)

Antes de subirla hay que generar una versión para PROD:

flutter build web

https://www.solutelabs.com/blog/flutter-for-web-how-to-deploy-a-flutter-web-appflutter

D:\home\flutter\cardio_gut>firebase login
Already logged in as j.claudio.grasso@gmail.com

D:\home\flutter\cardio_gut>firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

D:\home\flutter\cardio_gut

? Are you ready to proceed? Yes
? Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Hosting: Configure files for F
irebase Hosting and (optionally) set up GitHub Action deploys

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

? Please select an option: Use an existing project
? Select a default Firebase project for this directory: cardio-gut (cardio-gut)
i  Using project cardio-gut (cardio-gut)

=== Hosting Setup

Your public directory is the folder (relative to your project directory) that
will contain Hosting assets to be uploaded with firebase deploy. If you
have a build process for your assets, use your build's output directory.

? What do you want to use as your public directory? build/web
? Configure as a single-page app (rewrite all urls to /index.html)? No
? Set up automatic builds and deploys with GitHub? No
? File build/web/404.html already exists. Overwrite? No
i  Skipping write of build/web/404.html
? File build/web/index.html already exists. Overwrite? No
i  Skipping write of build/web/index.html

i  Writing configuration info to firebase.json...
i  Writing project information to .firebaserc...

+  Firebase initialization complete!

D:\home\flutter\cardio_gut>







