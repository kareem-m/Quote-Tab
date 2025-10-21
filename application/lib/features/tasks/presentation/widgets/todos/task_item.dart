import 'package:clean_quote_tab_todo/core/constants/const_colors.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/todos/check_icon.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/todos/delete_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskItem extends ConsumerWidget {
  final TaskEntity todo;
  const TaskItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: 60,
          margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
          decoration: BoxDecoration(
            color: todo.completed == false ? Colors.white : completedTaskColor,
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
                      todo.title,
                      style: TextStyle(
                        color: todo.completed == false
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
                    CheckIcon(todo: todo),
                    //delete
                    DeleteIcon(todo: todo),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (todo.completed)
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
