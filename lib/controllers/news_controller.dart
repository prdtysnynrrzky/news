import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/models/news.dart';

class NewsController {
  final String apiUrl = "https://newsapi.org/v2/top-headlines";
  final String apiKey = "c0d8dced7f974808a8be2496c84ee86f";

  Future<List<News>> fetchNews(String country) async {
    final response =
        await http.get(Uri.parse("$apiUrl?country=$country&apiKey=$apiKey"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<News> newsList = (data['articles'] as List)
          .map((article) => News.fromJson(article))
          .toList();
      return newsList;
    } else {
      throw Exception("Failed to fetch news");
    }
  }
}
