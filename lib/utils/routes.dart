import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/assignments_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/add_assignments_screen.dart';
import '../screens/add_session_screen.dart';
import '../models/assignments.dart';
import '../models/session.dart';

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

      case AppRoutes.assignments:
        return MaterialPageRoute(builder: (_) => const AssignmentsScreen());

      case AppRoutes.schedule:
        return MaterialPageRoute(builder: (_) => const ScheduleScreen());

      case AppRoutes.addAssignment:
        return MaterialPageRoute(builder: (_) => const AddAssignmentScreen());

      case AppRoutes.editAssignment:
        final assignment = settings.arguments as Assignment?;
        return MaterialPageRoute(
          builder: (_) => AddAssignmentScreen(assignment: assignment),
        );

      case AppRoutes.addSession:
        return MaterialPageRoute(builder: (_) => const AddSessionScreen());

      case AppRoutes.editSession:
        final session = settings.arguments as Session?;
        return MaterialPageRoute(
          builder: (_) => AddSessionScreen(session: session),
        );

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
