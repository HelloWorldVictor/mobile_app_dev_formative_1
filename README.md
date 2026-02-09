# ALU Academic Platform

A Flutter mobile application designed to help African Leadership University (ALU) students manage their academic responsibilities, track assignments, schedule sessions, and monitor attendance.

## Features

### 🏠 Dashboard
- Current academic week display
- Today's scheduled sessions
- Assignments due within 7 days
- Real-time attendance percentage with 75% warning
- Summary of pending assignments

### 📝 Assignment Management
- Create, edit, and delete assignments
- Set priority levels (High/Medium/Low)
- Mark assignments as complete
- Sort by due date
- Course-based organization

### 📅 Session Scheduling
- Schedule academic sessions with date/time
- Multiple session types: Class, Mastery Session, Study Group, PSL Meeting
- Location tracking
- Attendance recording (Present/Absent)
- Weekly schedule view

### 📊 Attendance Tracking
- Automatic attendance percentage calculation
- Visual warnings when below 75%
- Session-by-session attendance history
- Dashboard integration

## Technical Architecture

### Project Structure
```
lib/
├── models/          # Data models (Assignment, Session)
├── screens/         # UI screens
├── services/        # Business logic (StorageService)
├── utils/           # Utilities (constants, database, routes)
└── main.dart        # App entry point
```

### Key Technologies
- **Flutter SDK**: ^3.10.4
- **SQLite**: Local data persistence
- **Material Design 3**: UI framework
- **Provider Pattern**: State management

### Database Schema
- **Assignments Table**: id, title, due_date, course, priority, is_completed
- **Sessions Table**: id, title, date, start_time, end_time, location, type, is_present

## Setup Instructions

### Prerequisites
- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation
1. Clone the repository
```bash
git clone [repository-url]
cd mobile_app_dev_formative_1
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run
```

## ALU Branding
The app implements ALU's official color palette:
- **Primary Red**: #D00D2D
- **Navy Blue**: #002E6D  
- **Sky Blue**: #6EC1E4
- **Success Green**: #61CE70

## Team Contributions
[Each team member should document their specific contributions here]

## Demo Video
[Link to demo video will be added here]

## Group Contribution Tracker
[Link to group contribution tracker will be added here]
