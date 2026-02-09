import 'package:flutter/material.dart';

class AppColors {
  // ALU Primary Colors - Enhanced
  static const Color primary = Color(0xFFE91E63); // Vibrant Pink
  static const Color primaryDark = Color(0xFFC2185B); // Deep Pink
  static const Color primaryLight = Color(0xFFF8BBD0); // Light Pink

  static const Color secondary = Color(0xFF1A237E); // Rich Indigo
  static const Color secondaryDark = Color(0xFF0D1642); // Deep Navy
  static const Color secondaryLight = Color(0xFF3949AB); // Bright Indigo

  static const Color accent = Color(0xFF00BCD4); // Cyan Accent
  static const Color accentLight = Color(0xFF80DEEA); // Light Cyan
  static const Color accentDark = Color(0xFF00838F); // Dark Cyan

  // Functional Colors - Enhanced
  static const Color success = Color(0xFF4CAF50); // Material Green
  static const Color successLight = Color(0xFF81C784); // Light Green
  static const Color warning = Color(0xFFFFA726); // Warm Orange
  static const Color warningLight = Color(0xFFFFCC80); // Light Orange
  static const Color danger = Color(0xFFE53935); // Vivid Red
  static const Color dangerLight = Color(0xFFEF5350); // Light Red
  static const Color info = Color(0xFF2196F3); // Bright Blue
  static const Color infoLight = Color(0xFF64B5F6); // Light Blue

  // Neutral Colors - Enhanced
  static const Color background = Color(0xFFF5F7FA); // Soft Blue-Grey
  static const Color backgroundDark = Color(0xFFECEFF1); // Darker Grey
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceElevated = Color(0xFFFAFBFC); // Slightly Off-White

  static const Color text = Color(0xFF212121); // Rich Black
  static const Color textSecondary = Color(0xFF616161); // Medium Grey
  static const Color textLight = Color(0xFF9E9E9E); // Light Grey
  static const Color textDisabled = Color(0xFFBDBDBD); // Disabled Grey

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0); // Light Border
  static const Color divider = Color(0xFFEEEEEE); // Subtle Divider

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStrings {
  static const String appName = 'ALU Academic Platform';
  static const String dashboard = 'Dashboard';
  static const String assignments = 'Assignments';
  static const String schedule = 'Schedule';

  // Assignment related
  static const String addAssignment = 'Add Assignment';
  static const String editAssignment = 'Edit Assignment';
  static const String assignmentTitle = 'Assignment Title';
  static const String courseName = 'Course Name';
  static const String dueDate = 'Due Date';
  static const String priority = 'Priority';
  static const String high = 'High';
  static const String medium = 'Medium';
  static const String low = 'Low';

  // Session related
  static const String addSession = 'Add Session';
  static const String editSession = 'Edit Session';
  static const String sessionTitle = 'Session Title';
  static const String location = 'Location';
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';
  static const String sessionType = 'Session Type';
  static const String classType = 'Class';
  static const String masteryType = 'Mastery Session';
  static const String studyGroupType = 'Study Group';
  static const String pslMeetingType = 'PSL Meeting';

  // Attendance related
  static const String attendance = 'Attendance';
  static const String attendanceWarning = 'Warning: Below 75%';
  static const String present = 'Present';
  static const String absent = 'Absent';

  // Form validation
  static const String required = 'Required';
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time';
}
