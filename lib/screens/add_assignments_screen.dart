import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/assignments.dart';
import '../services/storage_service.dart';

class AddAssignmentScreen extends StatefulWidget {
  final Assignment? assignment;

  const AddAssignmentScreen({super.key, this.assignment});

  @override
  AddAssignmentScreenState createState() => AddAssignmentScreenState();
}

class AddAssignmentScreenState extends State<AddAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _dueDate;
  String _priority = AppStrings.medium;

  bool get _isEditing => widget.assignment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.assignment!.title;
      _courseController.text = widget.assignment!.course;
      _dueDate = widget.assignment!.dueDate;
      _priority = widget.assignment!.priority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _saveAssignment() async {
    if (!_formKey.currentState!.validate()) return;

    final assignment = Assignment(
      id: _isEditing ? widget.assignment!.id : null,
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
      dueDate: _dueDate!,
      priority: _priority,
      isCompleted: _isEditing ? widget.assignment!.isCompleted : false,
    );

    bool success;
    if (_isEditing) {
      success = await StorageService.updateAssignment(assignment);
    } else {
      success = await StorageService.addAssignment(assignment);
    }

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Assignment updated' : 'Assignment added'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving assignment'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select due date',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Date out of range',
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppStrings.editAssignment : AppStrings.addAssignment,
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: AppStrings.assignmentTitle,
                  border: OutlineInputBorder(),
                  hintText: 'Enter assignment title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: AppStrings.courseName,
                  border: OutlineInputBorder(),
                  hintText: 'Enter course name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: AppStrings.dueDate,
                      border: const OutlineInputBorder(),
                      hintText: AppStrings.selectDate,
                      suffixIcon: const Icon(Icons.calendar_today),
                      errorText: _dueDate == null ? AppStrings.required : null,
                    ),
                    controller: TextEditingController(
                      text: _dueDate != null
                          ? _dueDate.toString().split(' ')[0]
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: AppStrings.priority,
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: AppStrings.high,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        AppStrings.high,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.medium,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        AppStrings.medium,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.low,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        AppStrings.low,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAssignment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Update Assignment' : 'Add Assignment',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}