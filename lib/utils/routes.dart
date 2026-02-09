import 'package:flutter/material.dart';
import '../screens/main_screen.dart';


/// Route names
class AppRoutes {
  static const String main = '/';
  static const String dashboard = '/dashboard';
  static const String assignments = '/assignments';
  static const String schedule = '/schedule';
  static const String addAssignment = '/add-assignment';
  static const String editAssignment = '/edit-assignment';
  static const String addSession = '/add-session';
  static const String editSession = '/edit-session';
}

/// Route configuration
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.main:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'Route not found: $routeName',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
