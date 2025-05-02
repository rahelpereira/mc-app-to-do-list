import 'package:doable_todo_list_app/helper/object_box.dart';
import 'package:doable_todo_list_app/screens/settings_page.dart';
import 'package:doable_todo_list_app/widgets/add_task_button.dart';
import 'package:doable_todo_list_app/widgets/spacing.dart';
import 'package:doable_todo_list_app/widgets/today_and_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doable_todo_list_app/entities.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> _tasks = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // void _loadTasks() {
  //   setState(() {
  //     _tasks = objectBox.getAllTodoItems();
  //     _isInitialized = true;
  //   });
  // }

  void _loadTasks() {
    // print("Loading tasks from database");
    final tasks = objectBox.getAllTodoItems();
    // print("Found ${tasks.length} tasks in database");

    setState(() {
      _tasks = tasks;
      _isInitialized = true;
    });
  }

// Add this method for explicit debugging
  // void _debugPrintAllTasks() {
  //   final allTasks = objectBox.getAllTodoItems();
  //   print("------ DEBUG: ALL TASKS ------");
  //   print("Total tasks in DB: ${allTasks.length}");
  //   for (var task in allTasks) {
  //     print("Task ID: ${task.id}, Description: ${task.description}");
  //   }
  //   print("------------------------------");
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be called when the widget is inserted into the tree
    // and when dependencies change
    // _debugPrintAllTasks();
  }

  void _deleteTask(int id) {
    objectBox.removeTodoItem(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: SvgPicture.asset("assets/trans_logo.svg"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                ).then((_) => _loadTasks());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AddTaskButton(onTaskAdded: _loadTasks),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: !_isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : _tasks.isEmpty
                        ? Center(
                            child: Text('No tasks yet. Add one!',
                                style:
                                    Theme.of(context).textTheme.displaySmall))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                              itemCount: _tasks.length,
                              itemBuilder: (context, index) {
                                final task = _tasks[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    title: Text(
                                      task.description,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 12, color: descriptionColor),
                                        const SizedBox(width: 4),
                                        Text(task.date,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                        const SizedBox(width: 10),
                                        Icon(Icons.access_time,
                                            size: 12, color: descriptionColor),
                                        const SizedBox(width: 4),
                                        Text(task.time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _deleteTask(task.id),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              const TodayAndFilterButton(),
              const Spacing(),
            ],
          ),
        ),
      ),
    );
  }
}
