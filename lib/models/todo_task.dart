enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityLabel on TaskPriority {
  String get label => switch (this) { TaskPriority.low => 'Low', TaskPriority.medium => 'Medium', TaskPriority.high => 'High', TaskPriority.urgent => 'Urgent' };
}

class TodoTask {
  const TodoTask({this.id, required this.title, this.description, this.isCompleted = false, this.priority = TaskPriority.medium, this.dueDate, required this.createdAt, required this.updatedAt, this.completedAt, this.projectId});
  final int? id; final String title; final String? description; final bool isCompleted; final TaskPriority priority; final DateTime? dueDate; final DateTime createdAt; final DateTime updatedAt; final DateTime? completedAt; final int? projectId;
  TodoTask copyWith({int? id, String? title, String? description, bool? isCompleted, TaskPriority? priority, DateTime? dueDate, bool clearDueDate = false, DateTime? updatedAt, DateTime? completedAt, bool clearCompletedAt = false, int? projectId}) => TodoTask(id: id ?? this.id, title: title ?? this.title, description: description ?? this.description, isCompleted: isCompleted ?? this.isCompleted, priority: priority ?? this.priority, dueDate: clearDueDate ? null : dueDate ?? this.dueDate, createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt, completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt, projectId: projectId ?? this.projectId);
}
