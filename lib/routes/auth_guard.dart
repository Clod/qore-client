import 'package:auto_route/auto_route.dart';
import '../assets/global_data.dart';
import '../util/auth_service.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {

  final AuthService authService;
  AuthGuard(this.authService);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    logger.d("Intentando navegar con authService.authenticated ${authService.authenticated}");
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if(authService.authenticated){
      // if user is authenticated we continue
      resolver.next(true);
    }else{
      // we redirect the user to our login page
      // tip: use resolver.redirect to have the redirected route
      // automatically removed from the stack when the resolver is completed
      resolver.redirect(LoginRoute(onResult: (success){
        // authService.authenticated = success;
        // if success == true the navigation will be resumed
        // else it will be aborted
        resolver.next(success);
      }));
    }
  }
}
