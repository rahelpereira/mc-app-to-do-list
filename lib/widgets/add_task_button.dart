import 'package:doable_todo_list_app/main.dart';
import 'package:doable_todo_list_app/screens/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback onTaskAdded;

  const AddTaskButton({super.key, required this.onTaskAdded});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Use push instead of pushNamed for better control
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskPage()),
        ).then((_) {
          print("Returned from AddTaskPage - refreshing tasks");
          onTaskAdded();
        });
      },
      backgroundColor: blackColor,
      elevation: 0,
      splashColor: blueColor,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        "assets/plus.svg",
        height: MediaQuery.of(context).size.height * 0.02,
      ),
    );
  }
}
