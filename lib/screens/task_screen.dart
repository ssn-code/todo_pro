import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo_task.dart';
import '../providers/task_providers.dart';
import 'settings_screen.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key, required this.themeMode, required this.onThemeChanged});
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  @override ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  int section = 0;
  Future<void> edit([TodoTask? task]) async {
    final result = await showDialog<TodoTask>(context: context, builder: (_) => TaskEditor(task: task));
    if (result != null) await ref.read(taskListProvider.notifier).save(result);
  }
  Future<void> settings() => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => SettingsScreen(themeMode: widget.themeMode, onThemeChanged: widget.onThemeChanged)));
  void select(int value) { if (value == 2) { settings(); } else { setState(() => section = value); } }
  @override Widget build(BuildContext context) {
    final async = ref.watch(taskListProvider);
    final wide = MediaQuery.sizeOf(context).width >= 700;
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load tasks\n$error', textAlign: TextAlign.center)),
      data: (tasks) => TaskContent(tasks: tasks, upcoming: section == 1, onEdit: edit, onToggle: (task, value) => ref.read(taskListProvider.notifier).toggle(task, value), onDelete: (task) => ref.read(taskListProvider.notifier).remove(task)),
    );
    return Scaffold(
      appBar: AppBar(title: Row(children: [Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 10), const Text('todo pro')]), actions: [IconButton(tooltip: 'Settings', onPressed: settings, icon: const Icon(Icons.tune))]),
      body: wide ? Row(children: [NavigationRail(selectedIndex: section, onDestinationSelected: select, labelType: NavigationRailLabelType.all, destinations: const [NavigationRailDestination(icon: Icon(Icons.today_outlined), label: Text('Today')), NavigationRailDestination(icon: Icon(Icons.event_outlined), label: Text('Upcoming')), NavigationRailDestination(icon: Icon(Icons.settings_outlined), label: Text('Settings'))]), Expanded(child: body)]) : body,
      floatingActionButton: section < 2 ? FloatingActionButton.extended(onPressed: edit, icon: const Icon(Icons.add), label: const Text('Add task')) : null,
      bottomNavigationBar: wide ? null : NavigationBar(selectedIndex: section, onDestinationSelected: select, destinations: const [NavigationDestination(icon: Icon(Icons.today_outlined), label: 'Today'), NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Upcoming'), NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings')]),
    );
  }
}

class TaskContent extends StatelessWidget {
  const TaskContent({super.key, required this.tasks, required this.upcoming, required this.onEdit, required this.onToggle, required this.onDelete});
  final List<TodoTask> tasks; final bool upcoming; final Future<void> Function([TodoTask?]) onEdit; final void Function(TodoTask, bool) onToggle; final void Function(TodoTask) onDelete;
  @override Widget build(BuildContext context) {
    final visible = upcoming ? tasks.where((task) => task.dueDate != null).toList() : tasks;
    final now = DateTime.now();
    return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 860), child: ListView(padding: const EdgeInsets.fromLTRB(24, 38, 24, 100), children: [Text(upcoming ? 'Upcoming' : 'Today', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text(upcoming ? 'Tasks with a scheduled date' : '${now.day}/${now.month}/${now.year}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)), const SizedBox(height: 30), if (visible.isEmpty) EmptyState(upcoming: upcoming) else ...visible.map((task) => TaskRow(task: task, onEdit: () => onEdit(task), onToggle: (value) => onToggle(task, value), onDelete: () => onDelete(task))) ])));
  }
}

class EmptyState extends StatelessWidget { const EmptyState({super.key, required this.upcoming}); final bool upcoming; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 70), child: Column(children: [Icon(upcoming ? Icons.event_available : Icons.task_alt, size: 32, color: Theme.of(context).colorScheme.onSurfaceVariant), const SizedBox(height: 14), Text(upcoming ? 'No upcoming tasks' : 'Nothing on your list yet', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 6), Text(upcoming ? 'Schedule a date to see tasks here.' : 'Add a task to give today some direction.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))])); }

class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task, required this.onEdit, required this.onToggle, required this.onDelete});
  final TodoTask task; final VoidCallback onEdit; final ValueChanged<bool> onToggle; final VoidCallback onDelete;
  @override Widget build(BuildContext context) { final colors = Theme.of(context).colorScheme; return InkWell(onTap: onEdit, child: Container(decoration: BoxDecoration(border: Border(top: BorderSide(color: colors.outlineVariant))), padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [Checkbox(value: task.isCompleted, onChanged: (value) => onToggle(value ?? false)), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null, color: task.isCompleted ? colors.onSurfaceVariant : null)), if (task.description?.isNotEmpty == true) Text(task.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant))])), if (task.dueDate != null) Text('${task.dueDate!.day}/${task.dueDate!.month}', style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant)), IconButton(tooltip: 'Delete', onPressed: () async { final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Delete task?'), content: const Text('This task will be permanently removed.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))])); if (confirmed == true) onDelete(); }, icon: const Icon(Icons.delete_outline, size: 20))]))); }
}

class TaskEditor extends StatefulWidget { const TaskEditor({super.key, this.task}); final TodoTask? task; @override State<TaskEditor> createState() => _TaskEditorState(); }
class _TaskEditorState extends State<TaskEditor> {
  final formKey = GlobalKey<FormState>(); late final TextEditingController title; late final TextEditingController description; late TaskPriority priority; DateTime? due;
  @override void initState() { super.initState(); title = TextEditingController(text: widget.task?.title); description = TextEditingController(text: widget.task?.description); priority = widget.task?.priority ?? TaskPriority.medium; due = widget.task?.dueDate; }
  @override void dispose() { title.dispose(); description.dispose(); super.dispose(); }
  Future<void> pickDate() async { final date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2100), initialDate: due ?? DateTime.now()); if (date != null) setState(() => due = date); }
  void save() { if (!formKey.currentState!.validate()) return; final now = DateTime.now(); Navigator.pop(context, TodoTask(id: widget.task?.id, title: title.text.trim(), description: description.text.trim().isEmpty ? null : description.text.trim(), priority: priority, dueDate: due, isCompleted: widget.task?.isCompleted ?? false, createdAt: widget.task?.createdAt ?? now, updatedAt: now, completedAt: widget.task?.completedAt)); }
  @override Widget build(BuildContext context) => AlertDialog(title: Text(widget.task == null ? 'New task' : 'Edit task'), content: Form(key: formKey, child: SizedBox(width: 400, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextFormField(controller: title, autofocus: true, decoration: const InputDecoration(labelText: 'Task name'), validator: (value) => value == null || value.trim().isEmpty ? 'Enter a task name' : null), const SizedBox(height: 12), TextField(controller: description, maxLines: 3, decoration: const InputDecoration(labelText: 'Description (optional)')), const SizedBox(height: 12), DropdownButtonFormField<TaskPriority>(initialValue: priority, decoration: const InputDecoration(labelText: 'Priority'), items: TaskPriority.values.map((item) => DropdownMenuItem(value: item, child: Text(item.label))).toList(), onChanged: (value) => setState(() => priority = value!)), const SizedBox(height: 8), Align(alignment: Alignment.centerLeft, child: TextButton.icon(onPressed: pickDate, icon: const Icon(Icons.event_outlined), label: Text(due == null ? 'Add due date' : 'Due ${due!.day}/${due!.month}/${due!.year}')))]))), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: save, child: Text(widget.task == null ? 'Add task' : 'Save'))]);
}
