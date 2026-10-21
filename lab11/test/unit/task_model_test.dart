
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('completed defaults to false', () {
      // Arrange
      final task = Task(id: '1', title: 'Homework');

      // Act
      final completed = task.completed;

      // Assert
      expect(completed, false);
    });

    test('toggle switches false to true and back', () {
      // Arrange
      final task = Task(id: '1', title: 'Homework');

      // Act & Assert
      task.toggle();
      expect(task.completed, true);

      task.toggle();
      expect(task.completed, false);
    });
  });
}
