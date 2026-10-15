
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client})
      : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    );

    try {
      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Không thể tải dữ liệu: ${response.statusCode}',
        );
      }

      final List<dynamic> jsonList =
      json.decode(response.body) as List<dynamic>;

      return jsonList
          .map((item) => Post.fromJson(
        item as Map<String, dynamic>,
      ))
          .toList();
    } on TimeoutException {
      throw Exception('Kết nối quá lâu. Vui lòng thử lại.');
    } on FormatException {
      throw Exception('Dữ liệu JSON không hợp lệ.');
    }
  }

  void dispose() {
    client.close();
  }
}
