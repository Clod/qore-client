import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/router.gr.dart';
import 'package:cardio_gut/util/auth_service.dart';

import '../assets/global_data.dart';

class RouteGuard extends AutoRedirectGuard {
  final AuthService authService;
  RouteGuard(this.authService) {
    // Clod: This will trigger whenever there is a change in authentication state.
    // The developer does not have to explicitly check for authentication anywhere.
    authService.addListener(() {
      if (!authService.authenticated) {
        reevaluate();
      }
    });
  }

  // Clod: onNavigation() is called anytime navigation takes place
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {

    if (authService.authenticated) return resolver.next();
    // Clod: DONE: Navigate to login screen
    router.push(
      LoginRoute(
        onLoginCallback: (_) {
          resolver.next();
          // Clod: Remove this login screen from our navigation stack, so when
          // user presses the back button they are not taken to a login screen again.
          router.removeLast();
        },
      ),
    );

  }
}