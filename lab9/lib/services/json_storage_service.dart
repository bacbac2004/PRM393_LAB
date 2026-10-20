
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/task_item.dart';

class JsonStorageService {
  static const String assetPath = 'assets/data/items.json';
  static const String fileName = 'tasks.json';

  Future<List<TaskItem>> loadFromAssets() async {
    final content = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(content) as List<dynamic>;

    return decoded
        .map((item) =>
        TaskItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<TaskItem>> loadFromStorage() async {
    final file = await _getFile();

    if (!await file.exists()) {
      final initialItems = await loadFromAssets();
      await saveToStorage(initialItems);
      return initialItems;
    }

    final content = await file.readAsString();
    final decoded = jsonDecode(content) as List<dynamic>;

    return decoded
        .map((item) =>
        TaskItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveToStorage(List<TaskItem> items) async {
    final file = await _getFile();

    final content = jsonEncode(
      items.map((item) => item.toJson()).toList(),
    );

    await file.writeAsString(content, flush: true);
  }
}
