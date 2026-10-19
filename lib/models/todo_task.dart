import 'package:flutter/material.dart';

class TodoTask {
  const TodoTask({
    required this.id,
    required this.title,
    this.dueTime,
    this.isComplete = false,
  });

  final int id;
  final String title;
  final TimeOfDay? dueTime;
  final bool isComplete;

  TodoTask copyWith({bool? isComplete}) => TodoTask(
    id: id,
    title: title,
    dueTime: dueTime,
    isComplete: isComplete ?? this.isComplete,
  );
}
