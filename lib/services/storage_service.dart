import '../models/assignments.dart';
import '../models/session.dart';
import '../utils/database_helper.dart';

class StorageService {
  // ==================== ASSIGNMENT METHODS ====================

  static Future<List<Assignment>> getAllAssignments() async {
    try {
      return await DatabaseHelper.getAllAssignments();
    } catch (e) {
      print('Error getting assignments: $e');
      return [];
    }
  }

  static Future<List<Assignment>> getUpcomingAssignments() async {
    try {
      return await DatabaseHelper.getUpcomingAssignments();
    } catch (e) {
      print('Error getting upcoming assignments: $e');
      return [];
    }
  }

  static Future<bool> addAssignment(Assignment assignment) async {
    try {
      await DatabaseHelper.insertAssignment(assignment);
      return true;
    } catch (e) {
      print('Error adding assignment: $e');
      return false;
    }
  }

  static Future<bool> updateAssignment(Assignment assignment) async {
    try {
      await DatabaseHelper.updateAssignment(assignment);
      return true;
    } catch (e) {
      print('Error updating assignment: $e');
      return false;
    }
  }

  static Future<bool> deleteAssignment(int id) async {
    try {
      await DatabaseHelper.deleteAssignment(id);
      return true;
    } catch (e) {
      print('Error deleting assignment: $e');
      return false;
    }
  }

  static Future<bool> toggleAssignmentCompletion(Assignment assignment) async {
    try {
      final updatedAssignment = assignment.copyWith(
        isCompleted: !assignment.isCompleted,
      );
      await DatabaseHelper.updateAssignment(updatedAssignment);
      return true;
    } catch (e) {
      print('Error toggling assignment completion: $e');
      return false;
    }
  }

  // ==================== SESSION METHODS ====================

  static Future<List<Session>> getAllSessions() async {
    try {
      return await DatabaseHelper.getAllSessions();
    } catch (e) {
      print('Error getting sessions: $e');
      return [];
    }
  }

  static Future<List<Session>> getTodaySessions() async {
    try {
      return await DatabaseHelper.getTodaySessions();
    } catch (e) {
      print('Error getting today sessions: $e');
      return [];
    }
  }

  static Future<List<Session>> getThisWeekSessions() async {
    try {
      return await DatabaseHelper.getThisWeekSessions();
    } catch (e) {
      print('Error getting this week sessions: $e');
      return [];
    }
  }

  static Future<bool> addSession(Session session) async {
    try {
      await DatabaseHelper.insertSession(session);
      return true;
    } catch (e) {
      print('Error adding session: $e');
      return false;
    }
  }

  static Future<bool> updateSession(Session session) async {
    try {
      await DatabaseHelper.updateSession(session);
      return true;
    } catch (e) {
      print('Error updating session: $e');
      return false;
    }
  }

  static Future<bool> deleteSession(int id) async {
    try {
      await DatabaseHelper.deleteSession(id);
      return true;
    } catch (e) {
      print('Error deleting session: $e');
      return false;
    }
  }

  static Future<bool> toggleSessionAttendance(Session session) async {
    try {
      final updatedSession = session.copyWith(isPresent: !session.isPresent);
      await DatabaseHelper.updateSession(updatedSession);
      return true;
    } catch (e) {
      print('Error toggling session attendance: $e');
      return false;
    }
  }

  // ==================== ATTENDANCE METHODS ====================

  static Future<double> getAttendancePercentage() async {
    try {
      return await DatabaseHelper.getAttendancePercentage();
    } catch (e) {
      print('Error getting attendance percentage: $e');
      return 0.0;
    }
  }

  static Future<Map<String, int>> getAttendanceCount() async {
    try {
      return await DatabaseHelper.getAttendanceCount();
    } catch (e) {
      print('Error getting attendance count: $e');
      return {'total': 0, 'present': 0, 'absent': 0};
    }
  }

  // ==================== UTILITY METHODS ====================

  static Future<bool> clearAllData() async {
    try {
      await DatabaseHelper.clearAllData();
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  // Get dashboard summary data
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final todaySessions = await getTodaySessions();
      final upcomingAssignments = await getUpcomingAssignments();
      final attendancePercentage = await getAttendancePercentage();
      final attendanceCount = await getAttendanceCount();

      // Get all assignments to count pending ones
      final allAssignments = await getAllAssignments();
      final pendingAssignments = allAssignments
          .where((a) => !a.isCompleted)
          .length;

      return {
        'todaySessions': todaySessions,
        'upcomingAssignments': upcomingAssignments,
        'attendancePercentage': attendancePercentage,
        'attendanceCount': attendanceCount,
        'pendingAssignments': pendingAssignments,
      };
    } catch (e) {
      print('Error getting dashboard data: $e');
      return {
        'todaySessions': <Session>[],
        'upcomingAssignments': <Assignment>[],
        'attendancePercentage': 0.0,
        'attendanceCount': {'total': 0, 'present': 0, 'absent': 0},
        'pendingAssignments': 0,
      };
    }
  }
}
