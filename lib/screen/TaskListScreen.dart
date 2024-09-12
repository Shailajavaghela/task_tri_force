import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/Controller/task_controller.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/screen/TaskEditScreen.dart';

class TaskListScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController()); // Initialize TaskController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade200,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade400,
        title: Text('To-Do List', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        // Reactive task list using Obx
        if (taskController.tasks.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/emptyscreen.png",
                  width: double.infinity,
                ),
              ),
              Center(
                child: Text(
                  'No task yet',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                ),
              ),
            ],
          ); // Show message if there are no tasks
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) {
              final task = taskController.tasks[index]; // Get task at the current index
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  height: 105,
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Optional margin
                  padding: EdgeInsets.all(8.0), // Optional padding
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100, // Background color
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                    title: Text(
                      style: TextStyle(fontSize: 20),
                      task.title,
                      overflow: TextOverflow.ellipsis, // Handle overflow
                      maxLines: 1, // Ensure single line
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 2, // Allow multiple lines for description
                        ),
                        SizedBox(height: 4.0), // Add spacing between description and date
                        Text(
                          '${task.dateTime.toLocal()}',
                          style: TextStyle(color: Colors.grey.shade600),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          maxLines: 1, // Ensure single line
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Mark task as complete or incomplete
                        IconButton(
                          icon: Icon(
                            task.isComplete ? Icons.check_box : Icons.check_box_outline_blank,
                            color: task.isComplete ? Colors.grey.shade800 : null,
                          ),
                          onPressed: () {
                            taskController.saveTask(Task(
                              title: task.title,
                              description: task.description,
                              dateTime: task.dateTime,
                              isComplete: !task.isComplete, // Toggle completion status
                            ));
                          },
                        ),
                        // Delete task with confirmation dialog
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () async {
                            // Show confirmation dialog
                            bool shouldDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Task'),
                                  content: Text('Are you sure you want to delete this task?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false); // Dismiss dialog with false
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true); // Dismiss dialog with true
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                            if (shouldDelete) {
                              taskController.deleteTask(index); // Delete the task if confirmed
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () async {
                      // Edit task
                      final updatedTask = await Get.to(() => TaskEditScreen(task: task));
                      if (updatedTask != null) {
                        taskController.saveTask(updatedTask); // Save updated task
                      }
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo.shade400,
        onPressed: () async {
          // Add new task
          final newTask = await Get.to(() => TaskEditScreen());
          if (newTask != null) {
            taskController.saveTask(newTask); // Save new task
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
