import 'package:auto_route/auto_route.dart';
import 'package:cardio_gut/routes/route_guard.dart';
// import 'package:cardio_gut/routes/route_guard.dart';
import 'package:cardio_gut/screens/about/about_screen.dart';
import 'package:cardio_gut/screens/dashboard/dashboard_screen.dart';
import 'package:cardio_gut/screens/dashboard/products/add_products/add_products_screen.dart';
import 'package:cardio_gut/screens/dashboard/products/products_screen.dart';
import 'package:cardio_gut/screens/dashboard/profile/profile_screen.dart';
// import 'package:cardio_gut/screens/login/login_screen.dart';
import 'package:cardio_gut/screens/home/home_screen.dart';

import '../screens/login/login_screen.dart';

// https://pub.dev/packages/auto_route#wrapping-routes
@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
        page: LoginScreen,
        name: 'LoginRoute',
        path: 'login'
    ),
    AutoRoute(
      page: HomeScreen,
      name: 'HomeRoute',
      path: '/',
    ),
    AutoRoute(
      page: DashboardScreen,
      name: 'DashboardRoute',
      path: '/dashboard',
      guards: [RouteGuard],
      children: <AutoRoute>[
        AutoRoute<EmptyRouterPage>(
          name: 'ProductsRoute',
          path: 'products',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              page: ProductsScreen,
              path: '',   // Clod: '' means this is the default screen when we hit this route.
            ),
            AutoRoute(
                page: AddProductsScreen,
                name: 'AddProductsRoute',
                path: 'add_products'),
          ],
        ),
        AutoRoute(
            page: ProfileScreen,
            name: 'ProfileRoute',
            path: 'profile'
        )
      ],
    ),
    AutoRoute(
        page: AboutScreen,
        name: 'AboutRouter',
        path: '/about'
    )
  ],
)
class $AppRouter {}   // Clod: AppRouter se va a crear automáticamente con el comando de abajo

// Clod: Después de armar este archivo se corre
// D:\flutter\bin\flutter packages pub run build_runner build --delete-conflicting-outputs