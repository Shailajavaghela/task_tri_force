import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/task.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;

  TaskEditScreen({this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController = TextEditingController(text: widget.task!.title);
      _descriptionController = TextEditingController(text: widget.task!.description);
      _selectedDateTime = widget.task!.dateTime;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedDateTime = DateTime.now();
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateTime) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final task = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: _selectedDateTime,
      );
      Get.back(result: task);  // Pass the task back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.indigo.shade200,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: _selectDateTime,
                  child: Text('Select Date and Time',style: TextStyle(color: Colors.indigo.shade500),),
                ),
                Text('Selected: ${_selectedDateTime.toLocal()}'),
                SizedBox(height: 16.0),
                // ElevatedButton(
                //
                //
                //   //onPressed: _saveTask,
                //   child: Text('Save'),
                // ),
                InkWell(
                  onTap: _saveTask,
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.indigo.shade400
                    ),
                    child: Center(child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 20),)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
