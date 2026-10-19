import 'package:flutter/material.dart';

import '../models/todo_task.dart';
import 'settings_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<TodoTask> _tasks = [];
  int _nextId = 0;

  Future<void> _openSettings() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => SettingsScreen(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ),
  );

  Future<void> _addTask() async {
    final task = await showDialog<TodoTask>(
      context: context,
      builder: (_) => AddTaskDialog(id: _nextId),
    );
    if (task == null || !mounted) return;
    setState(() {
      _tasks.add(task);
      _nextId++;
    });
  }

  void _toggleTask(TodoTask task, bool isComplete) {
    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      _tasks[index] = task.copyWith(isComplete: isComplete);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final completedCount = _tasks.where((task) => task.isComplete).length;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        titleSpacing: 24,
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: colors.primary, size: 22),
            const SizedBox(width: 10),
            Text(
              'todo pro',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: _openSettings,
            icon: const Icon(Icons.tune),
          ),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colors.outlineVariant),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final horizontalPadding = isMobile ? 22.0 : 48.0;
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isMobile ? 34 : 52,
                  horizontalPadding,
                  40,
                ),
                children: [
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDate(now),
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'Tasks',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tasks.isEmpty
                            ? ''
                            : '$completedCount/${_tasks.length}',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _addTask,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add task'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_tasks.isEmpty)
                    _EmptyTasks(onAddTask: _addTask)
                  else
                    ..._tasks.map(
                      (task) => _TaskRow(
                        task: task,
                        onChanged: (value) => _toggleTask(task, value ?? false),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks({required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.task_alt, size: 28, color: colors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'Nothing on your list yet',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 5),
          Text(
            'Add a task to give today some direction.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onAddTask,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add your first task'),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task, required this.onChanged});

  final TodoTask task;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Checkbox(value: task.isComplete, onChanged: onChanged),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: task.isComplete ? colors.onSurfaceVariant : null,
                decoration: task.isComplete ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (task.dueTime != null) ...[
            const SizedBox(width: 12),
            Text(
              task.dueTime!.format(context),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.id});

  final int id;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  TimeOfDay? _dueTime;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectDueTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
    );
    if (selected != null) setState(() => _dueTime = selected);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      TodoTask(
        id: widget.id,
        title: _titleController.text.trim(),
        dueTime: _dueTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New task'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Task name',
                  hintText: 'What needs to get done?',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a task name'
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _selectDueTime,
                icon: const Icon(Icons.schedule, size: 18),
                label: Text(
                  _dueTime == null
                      ? 'Add due time'
                      : 'Due ${_dueTime!.format(context)}',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add task')),
      ],
    );
  }
}
