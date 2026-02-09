class Assignment {
  int? id;
  String title;
  DateTime dueDate;
  String course;
  String priority; // 'High', 'Medium', 'Low'
  bool isCompleted;

  Assignment({
    this.id,
    required this.title,
    required this.dueDate,
    required this.course,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  // Convert Assignment to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'due_date': dueDate.millisecondsSinceEpoch,
      'course': course,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  // Create Assignment from Map (database)
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['due_date']),
      course: map['course'],
      priority: map['priority'],
      isCompleted: map['is_completed'] == 1,
    );
  }

  // Create copy with updated values
  Assignment copyWith({
    int? id,
    String? title,
    DateTime? dueDate,
    String? course,
    String? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      course: course ?? this.course,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Check if assignment is overdue
  bool get isOverdue {
    final now = DateTime.now();
    return !isCompleted && dueDate.isBefore(now);
  }

  // Check if assignment is due within 7 days
  bool get isDueSoon {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));
    return !isCompleted &&
        dueDate.isAfter(now) &&
        dueDate.isBefore(sevenDaysFromNow);
  }

  // Get priority color
  String get priorityColor {
    switch (priority) {
      case 'High':
        return '#D00D2D'; // Red
      case 'Medium':
        return '#E0C25E'; // Gold
      case 'Low':
        return '#61CE70'; // Green
      default:
        return '#E0C25E'; // Gold
    }
  }
}
