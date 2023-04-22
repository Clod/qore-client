// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/foundation.dart' as _i10;
import 'package:flutter/material.dart' as _i8;

import '../model/paciente.dart' as _i11;
import '../screens/about/about_screen.dart' as _i5;
import '../screens/dashboard/patients/add_patients/add_patient_screen.dart'
    as _i4;
import '../screens/dashboard/patients/patients_screen.dart' as _i3;
import '../screens/dashboard/profile/edit_patient_screen.dart' as _i6;
import '../screens/home/home_screen.dart' as _i2;
import '../screens/login/login_screen.dart' as _i1;
import 'route_guard.dart' as _i9;

class AppRouter extends _i7.RootStackRouter {
  AppRouter(
      {_i8.GlobalKey<_i8.NavigatorState>? navigatorKey,
      required this.routeGuard})
      : super(navigatorKey);

  final _i9.RouteGuard routeGuard;

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i1.LoginScreen(
              key: args.key, onLoginCallback: args.onLoginCallback));
    },
    HomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.HomeScreen());
    },
    PatientsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.PatientsScreen());
    },
    AddPatientRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AddPatientScreen());
    },
    AboutRouter.name: (routeData) {
      final args = routeData.argsAs<AboutRouterArgs>();
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.AboutScreen(key: args.key, parametro: args.parametro));
    },
    EditPatientRoute.name: (routeData) {
      final args = routeData.argsAs<EditPatientRouteArgs>();
      return _i7.MaterialPageX<dynamic>(
          routeData: routeData,
          child:
              _i6.EditPatientScreen(key: args.key, parametro: args.parametro));
    }
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(LoginRoute.name, path: 'login'),
        _i7.RouteConfig(HomeRoute.name, path: '/'),
        _i7.RouteConfig(PatientsRoute.name,
            path: 'patients', guards: [routeGuard]),
        _i7.RouteConfig(AddPatientRoute.name,
            path: 'add_patient', guards: [routeGuard]),
        _i7.RouteConfig(AboutRouter.name, path: '/about'),
        _i7.RouteConfig(EditPatientRoute.name,
            path: 'edit_patient', guards: [routeGuard])
      ];
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<LoginRouteArgs> {
  LoginRoute({_i10.Key? key, required dynamic Function(bool) onLoginCallback})
      : super(LoginRoute.name,
            path: 'login',
            args: LoginRouteArgs(key: key, onLoginCallback: onLoginCallback));

  static const String name = 'LoginRoute';
}

class LoginRouteArgs {
  const LoginRouteArgs({this.key, required this.onLoginCallback});

  final _i10.Key? key;

  final dynamic Function(bool) onLoginCallback;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onLoginCallback: $onLoginCallback}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.PatientsScreen]
class PatientsRoute extends _i7.PageRouteInfo<void> {
  const PatientsRoute() : super(PatientsRoute.name, path: 'patients');

  static const String name = 'PatientsRoute';
}

/// generated route for
/// [_i4.AddPatientScreen]
class AddPatientRoute extends _i7.PageRouteInfo<void> {
  const AddPatientRoute() : super(AddPatientRoute.name, path: 'add_patient');

  static const String name = 'AddPatientRoute';
}

/// generated route for
/// [_i5.AboutScreen]
class AboutRouter extends _i7.PageRouteInfo<AboutRouterArgs> {
  AboutRouter({_i10.Key? key, required String parametro})
      : super(AboutRouter.name,
            path: '/about',
            args: AboutRouterArgs(key: key, parametro: parametro));

  static const String name = 'AboutRouter';
}

class AboutRouterArgs {
  const AboutRouterArgs({this.key, required this.parametro});

  final _i10.Key? key;

  final String parametro;

  @override
  String toString() {
    return 'AboutRouterArgs{key: $key, parametro: $parametro}';
  }
}

/// generated route for
/// [_i6.EditPatientScreen]
class EditPatientRoute extends _i7.PageRouteInfo<EditPatientRouteArgs> {
  EditPatientRoute({_i10.Key? key, required _i11.Paciente parametro})
      : super(EditPatientRoute.name,
            path: 'edit_patient',
            args: EditPatientRouteArgs(key: key, parametro: parametro));

  static const String name = 'EditPatientRoute';
}

class EditPatientRouteArgs {
  const EditPatientRouteArgs({this.key, required this.parametro});

  final _i10.Key? key;

  final _i11.Paciente parametro;

  @override
  String toString() {
    return 'EditPatientRouteArgs{key: $key, parametro: $parametro}';
  }
}
