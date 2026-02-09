import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/assignment.dart';
import '../models/session.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _dbName = 'academic_platform.db';
  static const int _dbVersion = 1;

  // Table names
  static const String assignmentsTable = 'assignments';
  static const String sessionsTable = 'sessions';

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createTables,
    );
  }

  // Create database tables
  static Future<void> _createTables(Database db, int version) async {
    // Create assignments table
    await db.execute('''
      CREATE TABLE $assignmentsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        due_date INTEGER NOT NULL,
        course TEXT NOT NULL,
        priority TEXT DEFAULT 'Medium',
        is_completed INTEGER DEFAULT 0
      )
    ''');

    // Create sessions table
    await db.execute('''
      CREATE TABLE $sessionsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date INTEGER NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        location TEXT,
        type TEXT NOT NULL,
        is_present INTEGER DEFAULT 0
      )
    ''');
  }

  // ==================== ASSIGNMENT OPERATIONS ====================

  // Insert new assignment
  static Future<int> insertAssignment(Assignment assignment) async {
    final db = await database;
    return await db.insert(assignmentsTable, assignment.toMap());
  }

  // Get all assignments
  static Future<List<Assignment>> getAllAssignments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      assignmentsTable,
      orderBy: 'due_date ASC',
    );
    return List.generate(maps.length, (i) => Assignment.fromMap(maps[i]));
  }

  // Get assignments due within 7 days
  static Future<List<Assignment>> getUpcomingAssignments() async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    final sevenDaysFromNow = DateTime.now()
        .add(const Duration(days: 7))
        .millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await db.query(
      assignmentsTable,
      where: 'is_completed = 0 AND due_date BETWEEN ? AND ?',
      whereArgs: [now, sevenDaysFromNow],
      orderBy: 'due_date ASC',
    );
    return List.generate(maps.length, (i) => Assignment.fromMap(maps[i]));
  }

  // Get assignments by course
  static Future<List<Assignment>> getAssignmentsByCourse(String course) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      assignmentsTable,
      where: 'course = ?',
      whereArgs: [course],
      orderBy: 'due_date ASC',
    );
    return List.generate(maps.length, (i) => Assignment.fromMap(maps[i]));
  }

  // Update assignment
  static Future<int> updateAssignment(Assignment assignment) async {
    final db = await database;
    return await db.update(
      assignmentsTable,
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  // Delete assignment
  static Future<int> deleteAssignment(int id) async {
    final db = await database;
    return await db.delete(assignmentsTable, where: 'id = ?', whereArgs: [id]);
  }

  // ==================== SESSION OPERATIONS ====================

  // Insert new session
  static Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert(sessionsTable, session.toMap());
  }

  // Get all sessions
  static Future<List<Session>> getAllSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      sessionsTable,
      orderBy: 'date ASC, start_time ASC',
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  // Get today's sessions
  static Future<List<Session>> getTodaySessions() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await db.query(
      sessionsTable,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'start_time ASC',
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  // Get this week's sessions
  static Future<List<Session>> getThisWeekSessions() async {
    final db = await database;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final startOfWeek = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day,
    ).millisecondsSinceEpoch;
    final endOfWeek = DateTime(
      weekEnd.year,
      weekEnd.month,
      weekEnd.day,
      23,
      59,
      59,
    ).millisecondsSinceEpoch;

    final List<Map<String, dynamic>> maps = await db.query(
      sessionsTable,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfWeek, endOfWeek],
      orderBy: 'date ASC, start_time ASC',
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  // Update session
  static Future<int> updateSession(Session session) async {
    final db = await database;
    return await db.update(
      sessionsTable,
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  // Delete session
  static Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete(sessionsTable, where: 'id = ?', whereArgs: [id]);
  }

  // ==================== ATTENDANCE OPERATIONS ====================

  // Get attendance percentage
  static Future<double> getAttendancePercentage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(sessionsTable);

    if (maps.isEmpty) return 0.0;

    final totalSessions = maps.length;
    final presentSessions = maps
        .where((session) => session['is_present'] == 1)
        .length;

    return (presentSessions / totalSessions) * 100;
  }

  // Get attendance count
  static Future<Map<String, int>> getAttendanceCount() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(sessionsTable);

    final totalSessions = maps.length;
    final presentSessions = maps
        .where((session) => session['is_present'] == 1)
        .length;
    final absentSessions = totalSessions - presentSessions;

    return {
      'total': totalSessions,
      'present': presentSessions,
      'absent': absentSessions,
    };
  }

  // ==================== UTILITY METHODS ====================

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    final db = await database;
    await db.delete(assignmentsTable);
    await db.delete(sessionsTable);
  }

  // Close database
  static Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
