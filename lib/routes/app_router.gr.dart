// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddPatientRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddPatientScreen(),
      );
    },
    EditPatientRoute.name: (routeData) {
      final args = routeData.argsAs<EditPatientRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: EditPatientScreen(
          key: args.key,
          parametro: args.parametro,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(
          key: args.key,
          onResult: args.onResult,
        ),
      );
    },
    PasswordRecoveryRoute.name: (routeData) {
      final args = routeData.argsAs<PasswordRecoveryRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PasswordRecoveryScreen(
          key: args.key,
          parametro: args.parametro,
        ),
      );
    },
    PatientsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const PatientsScreen(),
      );
    },
  };
}

/// generated route for
/// [AddPatientScreen]
class AddPatientRoute extends PageRouteInfo<void> {
  const AddPatientRoute({List<PageRouteInfo>? children})
      : super(
          AddPatientRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddPatientRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EditPatientScreen]
class EditPatientRoute extends PageRouteInfo<EditPatientRouteArgs> {
  EditPatientRoute({
    Key? key,
    required Paciente parametro,
    List<PageRouteInfo>? children,
  }) : super(
          EditPatientRoute.name,
          args: EditPatientRouteArgs(
            key: key,
            parametro: parametro,
          ),
          initialChildren: children,
        );

  static const String name = 'EditPatientRoute';

  static const PageInfo<EditPatientRouteArgs> page =
      PageInfo<EditPatientRouteArgs>(name);
}

class EditPatientRouteArgs {
  const EditPatientRouteArgs({
    this.key,
    required this.parametro,
  });

  final Key? key;

  final Paciente parametro;

  @override
  String toString() {
    return 'EditPatientRouteArgs{key: $key, parametro: $parametro}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    required dynamic Function(bool) onResult,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            onResult: onResult,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    required this.onResult,
  });

  final Key? key;

  final dynamic Function(bool) onResult;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, onResult: $onResult}';
  }
}

/// generated route for
/// [PasswordRecoveryScreen]
class PasswordRecoveryRoute extends PageRouteInfo<PasswordRecoveryRouteArgs> {
  PasswordRecoveryRoute({
    Key? key,
    required String parametro,
    List<PageRouteInfo>? children,
  }) : super(
          PasswordRecoveryRoute.name,
          args: PasswordRecoveryRouteArgs(
            key: key,
            parametro: parametro,
          ),
          initialChildren: children,
        );

  static const String name = 'PasswordRecoveryRoute';

  static const PageInfo<PasswordRecoveryRouteArgs> page =
      PageInfo<PasswordRecoveryRouteArgs>(name);
}

class PasswordRecoveryRouteArgs {
  const PasswordRecoveryRouteArgs({
    this.key,
    required this.parametro,
  });

  final Key? key;

  final String parametro;

  @override
  String toString() {
    return 'PasswordRecoveryRouteArgs{key: $key, parametro: $parametro}';
  }
}

/// generated route for
/// [PatientsScreen]
class PatientsRoute extends PageRouteInfo<void> {
  const PatientsRoute({List<PageRouteInfo>? children})
      : super(
          PatientsRoute.name,
          initialChildren: children,
        );

  static const String name = 'PatientsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
