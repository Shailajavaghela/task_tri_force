import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:todo_list/model/task.dart';


class TaskController extends GetxController {
  var tasks = <Task>[].obs; // Reactive list of tasks

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // Load tasks when the controller is initialized
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    tasks.value = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
  }

  // Add or update a task
  Future<void> saveTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final existingTaskIndex = tasks.indexWhere((t) => t.title == task.title && t.dateTime == task.dateTime);
    if (existingTaskIndex >= 0) {
      tasks[existingTaskIndex] = task;
    } else {
      tasks.add(task);
    }
    await saveTasksToPrefs();
  }

  // Delete a task
  Future<void> deleteTask(int index) async {
    tasks.removeAt(index);
    await saveTasksToPrefs();
  }

  // Save all tasks to SharedPreferences
  Future<void> saveTasksToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }
}
