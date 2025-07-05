// import 'dart:convert';
// import 'dart:math';

// import 'package:blog_app/news/newsArt.dart';
// import 'package:http/http.dart';
// // import 'package:news/newsArt.dart';

// class FetchNews {
//   static List sourcesId = [
//     "abc-news",
//     "bbc-news",
//     "bbc-sport",
//     "business-insider",
//     "engadget",
//     "entertainment-weekly",
//     "espn",
//     "espn-cric-info",
//     "financial-post",
//     "fox-news",
//     "fox-sports",
//     "globo",
//     "google-news",
//     "google-news-in",
//     "medical-news-today",
//     "national-geographic",
//     "news24",
//     "new-scientist",
//     "new-york-magazine",
//     "next-big-future",
//     "techcrunch",
//     "techradar",
//     "the-hindu",
//     "the-wall-street-journal",
//     "the-washington-times",
//     "time",
//     "usa-today",
//   ];
//   static Future<NewsArt> fetchNews() async {
//     final _random = new Random();
//     var sourceId = sourcesId[_random.nextInt(sourcesId.length)];
//     print(sourceId);

//     Response response = await get(Uri.parse(
//         'https://newsapi.org/v2/top-headlines?sources=$sourceId&apiKey=d4448dabf4104b2391bf926bf3ba4a3f'));

//     Map body_data = jsonDecode(response.body);
//     List articles = body_data['articles'];
//     // print(articles);

//     final _Newrandom = new Random();
//     var myArticle = articles[_random.nextInt(articles.length)];
//     print(myArticle);

//     return NewsArt.fromAPItoApp(myArticle);
//   }
// }
// lib/news/fetchNews.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'newsArt.dart';

class FetchNews {
  static const String _apiKey = 'd4448dabf4104b2391bf926bf3ba4a3f';
  static const String _base = 'https://newsapi.org/v2';

  /// 1) Try top-headlines?country=in
  /// 2) If empty or error, fall back to sources=google-news-in
  static Future<List<NewsArt>> fetchIndiaHeadlines() async {
    // Step 1: by country
    final uriCountry = Uri.parse(
        '$_base/top-headlines?country=in&pageSize=20&apiKey=$_apiKey');
    final respCountry = await http.get(uriCountry);

    if (respCountry.statusCode == 200) {
      final body = json.decode(respCountry.body) as Map<String, dynamic>;
      final list = (body['articles'] as List<dynamic>?) ?? [];
      if (list.isNotEmpty) {
        return list
            .map((j) => NewsArt.fromJson(j as Map<String, dynamic>))
            .toList();
      }
    } else {
      print('Country fetch error: ${respCountry.statusCode}');
    }

    // Step 2: fallback to known Indian source
    final uriSource = Uri.parse(
        '$_base/top-headlines?sources=google-news-in&pageSize=20&apiKey=$_apiKey');
    final respSource = await http.get(uriSource);

    if (respSource.statusCode == 200) {
      final body = json.decode(respSource.body) as Map<String, dynamic>;
      final list = (body['articles'] as List<dynamic>?) ?? [];
      return list
          .map((j) => NewsArt.fromJson(j as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Fallback fetch failed: ${respSource.statusCode}');
    }
  }

  /// Global headlines by category (unchanged)
  static Future<List<NewsArt>> fetchGlobalByCategory(String category) async {
    final uri = Uri.parse(
      '$_base/top-headlines?language=en&category=$category&pageSize=50&apiKey=$_apiKey',
    );
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception('Failed to load global news (${resp.statusCode})');
    }

    final body = json.decode(resp.body) as Map<String, dynamic>;
    final articles = (body['articles'] as List<dynamic>?) ?? [];

    return articles
        .map((j) => NewsArt.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
