
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

Widget createTestApp(TaskRepository repository) {
  return MaterialApp(
    home: TaskListScreen(repository: repository),
  );
}

void main() {
  testWidgets('shows empty state', (tester) async {
    final repository = TaskRepository();

    await tester.pumpWidget(createTestApp(repository));

    expect(
      find.text('No tasks yet. Add one!'),
      findsOneWidget,
    );
  });

  testWidgets('adds a task', (tester) async {
    final repository = TaskRepository();

    await tester.pumpWidget(createTestApp(repository));

    await tester.enterText(
      find.byKey(const Key('taskInputField')),
      'Finish homework',
    );
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();

    expect(find.text('Finish homework'), findsOneWidget);
  });

  testWidgets('shows multiple tasks', (tester) async {
    final repository = TaskRepository();

    await tester.pumpWidget(createTestApp(repository));

    for (final title in ['Task One', 'Task Two']) {
      await tester.enterText(
        find.byKey(const Key('taskInputField')),
        title,
      );
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();
    }

    expect(find.text('Task One'), findsOneWidget);
    expect(find.text('Task Two'), findsOneWidget);
  });
}
