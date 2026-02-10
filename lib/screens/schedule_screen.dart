import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  List<Session> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      isLoading = true;
    });

    final loadedSessions = await StorageService.getAllSessions();

    setState(() {
      sessions = loadedSessions;
      isLoading = false;
    });
  }

  Future<void> _toggleSessionAttendance(Session session) async {
    final success = await StorageService.toggleSessionAttendance(session);
    if (success) {
      _loadSessions();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            session.isPresent ? 'Marked as absent' : 'Marked as present',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _deleteSession(Session session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: Text('Are you sure you want to delete "${session.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await StorageService.deleteSession(session.id!);
      if (success) {
        _loadSessions();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session deleted'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _editSession(Session session) {
    Navigator.pushNamed(
      context,
      AppRoutes.editSession,
      arguments: session,
    ).then((_) => _loadSessions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.schedule),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addSession,
          ).then((_) => _loadSessions());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadSessions,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  return _buildSessionCard(sessions[index]);
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'No sessions scheduled yet',
            style: TextStyle(fontSize: 18, color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first session',
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(
            int.parse(session.typeColor.replaceAll('#', '0xFF')),
          ),
          child: Icon(session.typeIcon, color: Colors.white, size: 24),
        ),
        title: Text(
          session.title,
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${session.date.toString().split(' ')[0]}'),
            Text(
              '${_formatTime(session.startTime)} - ${_formatTime(session.endTime)}',
            ),
            if (session.location.isNotEmpty) Text('📍 ${session.location}'),
            Text('Type: ${session.type}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                session.isPresent
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: session.isPresent ? AppColors.success : Colors.grey,
              ),
              onPressed: () => _toggleSessionAttendance(session),
              tooltip: session.isPresent ? 'Mark absent' : 'Mark present',
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editSession(session);
                } else if (value == 'delete') {
                  _deleteSession(session);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

