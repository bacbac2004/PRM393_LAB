
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({
    super.key,
    required this.repository,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    widget.repository.addTask(
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
      ),
    );

    _controller.clear();
    setState(() {});
  }

  Future<void> _openDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Taskly')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter task title',
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                IconButton(
                  key: const Key('addTaskButton'),
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  key: ValueKey('task-${task.id}'),
                  title: Text(task.title),
                  leading: Checkbox(
                    value: task.completed,
                    onChanged: (_) {
                      setState(() => task.toggle());
                    },
                  ),
                  onTap: () => _openDetail(task),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.repository.deleteTask(task.id);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
