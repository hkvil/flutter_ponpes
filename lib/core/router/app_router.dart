import 'package:flutter/material.dart';

import '../../screens/splash/splash_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/menu/menu_screen.dart';
import '../../screens/login_screen.dart';
import '../../core/constants/menu_lists.dart';

/// Defines all named routes and handles route generation for the app.
///
/// The [onGenerateRoute] function maps route names to page builders. If
/// additional arguments are provided when navigating to a page, they are
/// passed along to the corresponding screen's constructor.
class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String menu = '/menu';

  /// Handles generation of routes based on the route name.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case menu:
        final MenuScreenArgs args = settings.arguments as MenuScreenArgs;
        final menuData = menuTree[args.title];
        return MaterialPageRoute(
            builder: (_) => MenuScreen(args: args, menuData: menuData));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
