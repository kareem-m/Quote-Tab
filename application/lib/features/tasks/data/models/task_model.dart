import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel{

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  bool completed;

  TaskModel({required this.id, required this.title, required this.completed});

  factory TaskModel.fromEntity(TaskEntity entity){
    return TaskModel(id: entity.id, title: entity.title, completed: entity.completed);
  }

  TaskEntity toEntity(){
    return TaskEntity(id: id, title: title, completed: completed);
  }

  factory TaskModel.fromJson(Map<String, dynamic> json){
    return TaskModel(id: json['_id'], title: json['title'], completed: json['completed']);
  }
}