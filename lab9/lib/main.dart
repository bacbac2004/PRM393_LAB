
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Lab9Page(),
));

class Lab9Page extends StatefulWidget {
  const Lab9Page({super.key});

  @override
  State<Lab9Page> createState() => _Lab9PageState();
}

class _Lab9PageState extends State<Lab9Page> {
  List<Map<String, dynamic>> items = [];
  int tab = 0;
  String keyword = '';

  Future<List<Map<String, dynamic>>> readAssets() async {
    final json = await rootBundle.loadString('assets/data/items.json');
    return List<Map<String, dynamic>>.from(jsonDecode(json));
  }

  Future<File> getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/items.json');
  }

  Future<void> loadFile() async {
    final file = await getFile();

    if (!await file.exists()) {
      items = await readAssets();
      await saveFile();
    } else {
      items = List<Map<String, dynamic>>.from(
        jsonDecode(await file.readAsString()),
      );
    }

    if (mounted) setState(() {});
  }

  Future<void> saveFile() async {
    final file = await getFile();
    await file.writeAsString(jsonEncode(items));
  }

  Future<void> editItem([Map<String, dynamic>? item]) async {
    final title = TextEditingController(text: item?['title'] ?? '');
    final desc = TextEditingController(text: item?['description'] ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Thêm công việc' : 'Sửa công việc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextField(
              controller: desc,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    if (result != true || title.text.trim().isEmpty) {
      title.dispose();
      desc.dispose();
      return;
    }

    setState(() {
      if (item == null) {
        final id = items.isEmpty
            ? 1
            : items.map((e) => (e['id'] as num).toInt())
            .reduce((a, b) => a > b ? a : b) + 1;

        items.add({
          'id': id,
          'title': title.text.trim(),
          'description': desc.text.trim(),
          'completed': false,
        });
      } else {
        item['title'] = title.text.trim();
        item['description'] = desc.text.trim();
      }
    });

    title.dispose();
    desc.dispose();
    await saveFile();
  }

  Future<void> deleteItem(Map<String, dynamic> item) async {
    setState(() => items.remove(item));
    await saveFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(['9.1 Assets', '9.2 Storage', '9.3 CRUD'][tab])),
      body: [
        FutureBuilder(
          future: readAssets(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: snapshot.hasError
                    ? Text('Lỗi: ${snapshot.error}')
                    : const CircularProgressIndicator(),
              );
            }
            return buildList(
              List<Map<String, dynamic>>.from(snapshot.data!),
              false,
            );
          },
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: loadFile,
                  child: const Text('Đọc file'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: saveFile,
                  child: const Text('Lưu file'),
                ),
              ],
            ),
            Expanded(child: buildList(items, false)),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => keyword = value),
              ),
            ),
            Expanded(
              child: buildList(
                items.where((e) =>
                    '${e['title']} ${e['description']}'
                        .toLowerCase().contains(keyword.toLowerCase())
                ).toList(),
                true,
              ),
            ),
          ],
        ),
      ][tab],
      floatingActionButton: tab == 2
          ? FloatingActionButton(
        onPressed: () => editItem(),
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) async {
          setState(() => tab = i);
          if (i == 1 || i == 2) await loadFile();
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.data_object), label: '9.1'),
          NavigationDestination(
              icon: Icon(Icons.save), label: '9.2'),
          NavigationDestination(
              icon: Icon(Icons.edit), label: '9.3'),
        ],
      ),
    );
  }

  Widget buildList(List<Map<String, dynamic>> data, bool editable) {
    if (data.isEmpty) return const Center(child: Text('Không có dữ liệu'));

    return ListView(
      children: data.map((item) => ListTile(
        title: Text(item['title']?.toString() ?? ''),
        subtitle: Text(item['description']?.toString() ?? ''),
        trailing: editable
            ? PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') editItem(item);
            if (value == 'delete') deleteItem(item);
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'edit', child: Text('Sửa')),
            PopupMenuItem(value: 'delete', child: Text('Xóa')),
          ],
        )
            : null,
      )).toList(),
    );
  }
}
