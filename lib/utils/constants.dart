import 'package:flutter/material.dart';

class AppColors {
  // ALU Primary Colors - From Official CSS Variables
  static const Color primary = Color(0xFFD00D2D); // ALU Red - Primary Buttons
  static const Color primaryDark = Color(0xFFB00A25); // Darker Red
  static const Color primaryLight = Color(0xFFE04A5F); // Lighter Red

  static const Color secondary = Color(0xFF002E6D); // ALU Navy Blue
  static const Color secondaryDark = Color(0xFF001F4D); // Deep Navy
  static const Color secondaryLight = Color(0xFF1A4A8A); // Lighter Navy

  static const Color accent = Color(0xFF6EC1E4); // ALU Sky Blue Accent
  static const Color accentLight = Color(0xFF9DD4ED); // Light Sky Blue
  static const Color accentDark = Color(0xFF4FA8CC); // Dark Sky Blue

  // Functional Colors - Using ALU Brand Colors
  static const Color success = Color(0xFF61CE70); // ALU Green
  static const Color successLight = Color(0xFF8EDBA0); // Light Green
  static const Color warning = Color(0xFFFFA726); // Warm Orange
  static const Color warningLight = Color(0xFFFFCC80); // Light Orange
  static const Color danger = Color(0xFFD00D2D); // ALU Red
  static const Color dangerLight = Color(0xFFE04A5F); // Light Red
  static const Color info = Color(0xFF6EC1E4); // ALU Sky Blue
  static const Color infoLight = Color(0xFF9DD4ED); // Light Sky Blue

  // Neutral Colors - Clean White Theme
  static const Color background = Color(0xFFFFFFFF); // Pure White
  static const Color backgroundDark = Color(0xFFF8F9FA); // Off White
  static const Color surface = Color(0xFFFFFFFF); // Pure White
  static const Color surfaceElevated = Color(0xFFFAFBFC); // Slightly Off-White

  static const Color text = Color(0xFF54595F); // ALU Secondary Text
  static const Color textSecondary = Color(0xFF7A7A7A); // ALU Text Color
  static const Color textLight = Color(0xFF9E9E9E); // Light Grey
  static const Color textDisabled = Color(0xFFBDBDBD); // Disabled Grey

  // Borders & Dividers
  static const Color border = Color(0xFFE5E7EB); // Light Border
  static const Color divider = Color(0xFFF3F4F6); // Subtle Divider

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
