
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/repositories/task_repository.dart';
import 'package:lab11/screens/task_list_screen.dart';

void main() {
  testWidgets('adds, edits, saves and shows updated title',
          (tester) async {
        final repository = TaskRepository();

        await tester.pumpWidget(
          MaterialApp(
            home: TaskListScreen(repository: repository),
          ),
        );

        // Add task
        await tester.enterText(
          find.byKey(const Key('taskInputField')),
          'Original title',
        );
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();

        expect(find.text('Original title'), findsOneWidget);

        // Open detail
        await tester.tap(find.text('Original title'));
        await tester.pumpAndSettle();

        // Edit title
        await tester.enterText(
          find.byKey(const Key('detailTitleField')),
          'Updated title',
        );
        await tester.tap(find.byKey(const Key('saveTaskButton')));
        await tester.pumpAndSettle();

        // Verify list
        expect(find.text('Updated title'), findsOneWidget);
        expect(find.text('Original title'), findsNothing);
      });
}
