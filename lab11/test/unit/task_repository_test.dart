
import 'package:flutter_test/flutter_test.dart';
import 'package:lab11/models/task.dart';
import 'package:lab11/repositories/task_repository.dart';

void main() {
  late TaskRepository repository;

  setUp(() {
    repository = TaskRepository();
  });

  test('addTask adds a task', () {
    // Arrange
    final task = Task(id: '1', title: 'Study');

    // Act
    repository.addTask(task);

    // Assert
    expect(repository.tasks.length, 1);
    expect(repository.tasks.first.title, 'Study');
  });

  test('deleteTask removes a task', () {
    // Arrange
    repository.addTask(Task(id: '1', title: 'Study'));

    // Act
    repository.deleteTask('1');

    // Assert
    expect(repository.tasks, isEmpty);
  });

  test('updateTask updates an existing task', () {
    // Arrange
    repository.addTask(Task(id: '1', title: 'Old title'));
    final updated = Task(id: '1', title: 'New title');

    // Act
    repository.updateTask(updated);

    // Assert
    expect(repository.tasks.first.title, 'New title');
  });
}
