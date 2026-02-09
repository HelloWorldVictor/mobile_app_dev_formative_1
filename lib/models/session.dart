import 'package:flutter/material.dart';

class Session {
  int? id;
  String title;
  DateTime date;
  TimeOfDay startTime;
  TimeOfDay endTime;
  String location;
  String type; // 'Class', 'Mastery Session', 'Study Group', 'PSL Meeting'
  bool isPresent;

  Session({
    this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.type,
    this.isPresent = false,
  });

  // Convert Session to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'start_time':
          '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      'end_time':
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      'location': location,
      'type': type,
      'is_present': isPresent ? 1 : 0,
    };
  }

  // Create Session from Map (database)
  factory Session.fromMap(Map<String, dynamic> map) {
    final startTimeStr = map['start_time'] as String;
    final endTimeStr = map['end_time'] as String;

    final startTimeParts = startTimeStr.split(':');
    final endTimeParts = endTimeStr.split(':');

    return Session(
      id: map['id'],
      title: map['title'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      location: map['location'] ?? '',
      type: map['type'],
      isPresent: map['is_present'] == 1,
    );
  }

  // Create copy with updated values
  Session copyWith({
    int? id,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? type,
    bool? isPresent,
  }) {
    return Session(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      type: type ?? this.type,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  // Check if session is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if session is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  // Get session type icon
  IconData get typeIcon {
    switch (type) {
      case 'Class':
        return Icons.school;
      case 'Mastery Session':
        return Icons.workspace_premium;
      case 'Study Group':
        return Icons.groups;
      case 'PSL Meeting':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  // Get session type color
  String get typeColor {
    switch (type) {
      case 'Class':
        return '#002E6D'; // Dark Blue
      case 'Mastery Session':
        return '#CC3366'; // Pink
      case 'Study Group':
        return '#6EC1E4'; // Light Blue
      case 'PSL Meeting':
        return '#61CE70'; // Green
      default:
        return '#54595F'; // Gray
    }
  }

  // Format duration
  String get duration {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final totalMinutes = endMinutes - startMinutes;

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }
}
