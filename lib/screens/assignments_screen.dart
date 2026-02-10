import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/routes.dart';
import '../models/assignments.dart';
import '../services/storage_service.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  AssignmentsScreenState createState() => AssignmentsScreenState();
}

class AssignmentsScreenState extends State<AssignmentsScreen> {
  List<Assignment> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    setState(() {
      isLoading = true;
    });

    final loadedAssignments = await StorageService.getAllAssignments();

    setState(() {
      assignments = loadedAssignments;
      isLoading = false;
    });
  }

  Future<void> _toggleAssignmentCompletion(Assignment assignment) async {
    final success = await StorageService.toggleAssignmentCompletion(assignment);
    if (success && mounted) {
      _loadAssignments();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            assignment.isCompleted
                ? 'Assignment marked as incomplete'
                : 'Assignment marked as complete',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _deleteAssignment(Assignment assignment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"?'),
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
      final success = await StorageService.deleteAssignment(assignment.id!);
      if (success && mounted) {
        _loadAssignments();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment deleted'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _editAssignment(Assignment assignment) {
    Navigator.pushNamed(
      context,
      AppRoutes.editAssignment,
      arguments: assignment,
    ).then((_) => _loadAssignments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.assignments),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.addAssignment,
          ).then((_) => _loadAssignments());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : assignments.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadAssignments,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  return _buildAssignmentCard(assignments[index]);
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
          Icon(Icons.assignment_outlined, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'No assignments yet',
            style: TextStyle(fontSize: 18, color: AppColors.textLight),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first assignment',
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: assignment.isCompleted,
          onChanged: (value) => _toggleAssignmentCompletion(assignment),
          activeColor: AppColors.primary,
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            decoration: assignment.isCompleted
                ? TextDecoration.lineThrough
                : null,
            color: assignment.isCompleted
                ? AppColors.textLight
                : AppColors.text,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course: ${assignment.course}'),
            Text('Due: ${assignment.dueDate.toString().split(' ')[0]}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(
                  int.parse(assignment.priorityColor.replaceAll('#', '0xFF')),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                assignment.priority,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editAssignment(assignment);
                } else if (value == 'delete') {
                  _deleteAssignment(assignment);
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
}