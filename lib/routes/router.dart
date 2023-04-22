import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/route_guard.dart';
import 'package:cardio_gut/screens/about/about_screen.dart';
import 'package:cardio_gut/screens/home/home_screen.dart';

import '../screens/dashboard/patients/add_patients/add_patient_screen.dart';
import '../screens/dashboard/patients/patients_screen.dart';
import '../screens/dashboard/profile/edit_patient_screen.dart';
import '../screens/login/login_screen.dart';
import 'package:flutter/foundation.dart';


// https://pub.dev/packages/auto_route#wrapping-routes
@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      page: LoginScreen,
      name: 'LoginRoute',
      path: 'login',
    ),
    AutoRoute(
      page: HomeScreen,
      name: 'HomeRoute',
      path: '/',
    ),
    AutoRoute(
      page: PatientsScreen,
      name: 'PatientsRoute',
      path: 'patients',
      // guards: kReleaseMode ? [RouteGuard] : null,
      guards: [RouteGuard],
    ),
    AutoRoute(
      page: AddPatientScreen,
      name: 'AddPatientRoute',
      path: 'add_patient',
      //guards: kReleaseMode ? [RouteGuard] : null,
      guards: [RouteGuard],
    ),
    AutoRoute(
      page: AboutScreen,
      name: 'AboutRouter',
      path: '/about',
    ),
    AutoRoute(
      page: EditPatientScreen,
      name: 'EditPatientRoute',
      // guards: kReleaseMode ? [RouteGuard] : null,
      guards: [RouteGuard],
      path: 'edit_patient',
    )
    // All routes within Dashboard are guarded
/*    AutoRoute(
      page: DashboardScreen,
      name: 'DashboardRoute',
      path: '/dashboard',
      guards: [RouteGuard],
      children: <AutoRoute>[
        AutoRoute<EmptyRouterPage>(
          // Empty screen used to host either Patients´ list screen or
          // add patient screen
          name: 'ProductsRoute',
          path: 'products',
          page: EmptyRouterPage,
          children: [
            // Patient´s list screen
            AutoRoute(
              page: ProductsScreen,
              path:
                  '', // Clod: '' means this is the default screen when we hit this route.
            ),
            // Add patient screen
            AutoRoute(
                page: AddPatientScreen,
                name: 'AddPatientRoute',
                path: 'add_patient'),
          ],
        ),
        AutoRoute(
            page: EditPatientScreen,
            name: 'EditPatientRoute',
            path: 'edit_patient')
      ],
    ),*/
    // AutoRoute(page: AboutScreen, name: 'AboutRouter', path: '/about')
  ],
)
class $AppRouter {
} // Clod: AppRouter se va a crear automáticamente con el comando de abajo

// Clod: Después de armar este archivo se corre
// D:\flutter\bin\flutter packages pub run build_runner build --delete-conflicting-outputs
