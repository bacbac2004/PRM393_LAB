
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/main.dart';

void main() {
  testWidgets('Taskly displays empty state', (tester) async {
    await tester.pumpWidget(const TasklyApp());

    expect(find.text('Taskly'), findsOneWidget);
    expect(find.text('No tasks yet. Add one!'), findsOneWidget);
  });
}
