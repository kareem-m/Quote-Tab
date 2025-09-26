import 'package:flutter/material.dart';
import 'package:quote_tab_todo/util/constants.dart';

class TaskItem extends StatelessWidget {
  final Map<String, dynamic> todo;
  final VoidCallback onCompleted;
  final VoidCallback onDeleted;

  const TaskItem({
    super.key,
    required this.todo,
    required this.onCompleted,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
          decoration: BoxDecoration(
            color: todo['completed'] == false
                ? Colors.white
                : completedTaskColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text(
                      todo['title'],
                      style: TextStyle(
                        color: todo['completed'] == false
                            ? Colors.black
                            : completedLineColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    //check
                    IconButton(
                      onPressed: onCompleted,
                      icon: const Icon(
                        Icons.check,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //delete
                    IconButton(
                      onPressed: onDeleted,
                      icon: const Icon(
                        Icons.close,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (todo['completed'] == true)
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              color: completedLineColor,
              width: size.width * 3 / 5,
              height: 4,
            ),
          ),
      ],
    );
  }
}
