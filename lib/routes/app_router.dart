import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/auth_guard.dart';
import 'package:cardio_gut/screens/about/about_screen.dart';
import 'package:cardio_gut/screens/home/home_screen.dart';
import 'package:cardio_gut/util/auth_service.dart';
import 'package:cardio_gut/model/paciente.dart';
import 'package:cardio_gut/screens/dashboard/patients/add_patients/add_patient_screen.dart';
import 'package:cardio_gut/screens/dashboard/patients/patients_screen.dart';
import 'package:cardio_gut/screens/dashboard/profile/edit_patient_screen.dart';
import 'package:cardio_gut/screens/login/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

// _$AppRouter is also genrated by the tool in said part
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  AuthService authService;

  AppRouter(this.authService);

  @override
  RouteType get defaultRouteType => const RouteType.material();

  // bool get authenticated => (delegate().reevaluateListenable as AuthService).authenticated;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page),
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
        ),
        AutoRoute(page: PatientsRoute.page, guards: [AuthGuard(authService)]),
        AutoRoute(page: AddPatientRoute.page, guards: [AuthGuard(authService)]),
        AutoRoute(page: EditPatientRoute.page, guards: [AuthGuard(authService)]),
        AutoRoute(page: AboutRoute.page),
      ];
}
