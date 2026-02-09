import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/session.dart';
import '../services/storage_service.dart';

class AddSessionScreen extends StatefulWidget {
  final Session? session;

  const AddSessionScreen({super.key, this.session});

  @override
  AddSessionScreenState createState() => AddSessionScreenState();
}

class AddSessionScreenState extends State<AddSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _sessionType = AppStrings.classType;

  bool get _isEditing => widget.session != null;

  final List<String> _sessionTypes = [
    AppStrings.classType,
    AppStrings.masteryType,
    AppStrings.studyGroupType,
    AppStrings.pslMeetingType,
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.session!.title;
      _locationController.text = widget.session!.location;
      _date = widget.session!.date;
      _startTime = widget.session!.startTime;
      _endTime = widget.session!.endTime;
      _sessionType = widget.session!.type;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveSession() async {
    if (!_formKey.currentState!.validate()) return;

    final session = Session(
      id: _isEditing ? widget.session!.id : null,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      date: _date!,
      startTime: _startTime!,
      endTime: _endTime!,
      type: _sessionType,
      isPresent: _isEditing ? widget.session!.isPresent : false,
    );

    bool success;
    if (_isEditing) {
      success = await StorageService.updateSession(session);
    } else {
      success = await StorageService.addSession(session);
    }

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Session updated' : 'Session added'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error saving session'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select session date',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Date out of range',
    );

    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      helpText: 'Select start time',
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
      helpText: 'Select end time',
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? AppStrings.editSession : AppStrings.addSession,
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
                  labelText: AppStrings.sessionTitle,
                  border: OutlineInputBorder(),
                  hintText: 'Enter session title',
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
                      labelText: 'Date',
                      border: const OutlineInputBorder(),
                      hintText: AppStrings.selectDate,
                      suffixIcon: const Icon(Icons.calendar_today),
                      errorText: _date == null ? AppStrings.required : null,
                    ),
                    controller: TextEditingController(
                      text: _date != null ? _date.toString().split(' ')[0] : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectStartTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: AppStrings.startTime,
                            border: const OutlineInputBorder(),
                            hintText: AppStrings.selectTime,
                            suffixIcon: const Icon(Icons.access_time),
                            errorText: _startTime == null
                                ? AppStrings.required
                                : null,
                          ),
                          controller: TextEditingController(
                            text: _startTime != null
                                ? _formatTime(_startTime!)
                                : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectEndTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: AppStrings.endTime,
                            border: const OutlineInputBorder(),
                            hintText: AppStrings.selectTime,
                            suffixIcon: const Icon(Icons.access_time),
                            errorText: _endTime == null
                                ? AppStrings.required
                                : null,
                          ),
                          controller: TextEditingController(
                            text: _endTime != null
                                ? _formatTime(_endTime!)
                                : '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: AppStrings.location,
                  border: OutlineInputBorder(),
                  hintText: 'Enter location (optional)',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sessionType,
                decoration: const InputDecoration(
                  labelText: AppStrings.sessionType,
                  border: OutlineInputBorder(),
                ),
                items: _sessionTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sessionType = value!;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(_isEditing ? 'Update Session' : 'Add Session'),
                ),
              ),
            ],
          ),
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
