import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_task.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());
final taskListProvider = AsyncNotifierProvider<TaskListNotifier, List<TodoTask>>(TaskListNotifier.new);
class TaskListNotifier extends AsyncNotifier<List<TodoTask>> {
  TaskRepository get _repo => ref.read(taskRepositoryProvider);
  @override Future<List<TodoTask>> build() => _repo.getAll();
  Future<void> save(TodoTask task) async { final old = state.asData?.value ?? const <TodoTask>[]; try { late final TodoTask saved; if (task.id == null) { saved = await _repo.insert(task); } else { await _repo.update(task); saved = task; } state = AsyncData([...old.where((x) => x.id != saved.id), saved]..sort(_sort)); } catch (e, s) { state = AsyncError(e, s); } }
  Future<void> toggle(TodoTask task, bool complete) => save(task.copyWith(isCompleted: complete, updatedAt: DateTime.now(), completedAt: complete ? DateTime.now() : null, clearCompletedAt: !complete));
  Future<void> remove(TodoTask task) async { final old = state.asData?.value ?? const <TodoTask>[]; state = AsyncData(old.where((x) => x.id != task.id).toList()); try { await _repo.delete(task.id!); } catch (e, s) { state = AsyncError(e, s); } }
  int _sort(TodoTask a, TodoTask b) { if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1; return (a.dueDate ?? DateTime(9999)).compareTo(b.dueDate ?? DateTime(9999)); }
}
