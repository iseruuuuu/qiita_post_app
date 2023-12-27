import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qiita_app/model/article.dart';

class QiitaClient {
  static Future<List<Article>> fetchArticle(
      {int page = 1, int perPage = 10}) async {
    const baseUrl = 'https://qiita.com/api/v2/items';
    final url = '$baseUrl?query=tag:Flutter&page=$page&per_page=$perPage';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonArray = json.decode(response.body);
      return jsonArray.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load article');
    }
  }
}
