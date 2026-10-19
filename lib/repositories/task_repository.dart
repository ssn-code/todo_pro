import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/todo_task.dart';

class TaskRepository {
  TaskRepository({AppDatabase? database}) : _database = database ?? AppDatabase.instance;
  final AppDatabase _database;
  Future<List<TodoTask>> getAll() async { final rows = await (await _database.database).query('tasks', orderBy: 'is_completed ASC, due_date ASC, created_at DESC'); return rows.map(_fromRow).toList(); }
  Future<TodoTask> insert(TodoTask task) async { final id = await (await _database.database).insert('tasks', _toRow(task), conflictAlgorithm: ConflictAlgorithm.abort); return task.copyWith(id: id); }
  Future<void> update(TodoTask task) async { await (await _database.database).update('tasks', _toRow(task), where: 'id = ?', whereArgs: [task.id]); }
  Future<void> delete(int id) async { await (await _database.database).delete('tasks', where: 'id = ?', whereArgs: [id]); }
  Map<String, Object?> _toRow(TodoTask t) => {'title': t.title, 'description': t.description, 'is_completed': t.isCompleted ? 1 : 0, 'priority': t.priority.name, 'due_date': t.dueDate?.millisecondsSinceEpoch, 'created_at': t.createdAt.millisecondsSinceEpoch, 'updated_at': t.updatedAt.millisecondsSinceEpoch, 'completed_at': t.completedAt?.millisecondsSinceEpoch, 'project_id': t.projectId};
  TodoTask _fromRow(Map<String, Object?> r) => TodoTask(id: r['id'] as int, title: r['title'] as String, description: r['description'] as String?, isCompleted: r['is_completed'] as int == 1, priority: TaskPriority.values.byName(r['priority'] as String), dueDate: _date(r['due_date']), createdAt: DateTime.fromMillisecondsSinceEpoch(r['created_at'] as int), updatedAt: DateTime.fromMillisecondsSinceEpoch(r['updated_at'] as int), completedAt: _date(r['completed_at']), projectId: r['project_id'] as int?);
  DateTime? _date(Object? value) => value == null ? null : DateTime.fromMillisecondsSinceEpoch(value as int);
}
