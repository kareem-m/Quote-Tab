import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final bool completed;

  const TaskEntity({required this.id, required this.title, required this.completed});

  factory TaskEntity.changeCompleted(TaskEntity todo) {
    return TaskEntity(
      id: todo.id,
      title: todo.title,
      completed: !todo.completed,
    );
  }
  
  @override
  
  List<Object?> get props => [id, title, completed];
}