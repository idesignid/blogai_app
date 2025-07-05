// import 'package:blog_app/news/fetchNews.dart';
// import 'package:blog_app/news/newsArt.dart';
// import 'package:blog_app/news/newscontainer.dart';
// import 'package:flutter/material.dart';

// // import 'package:news/fetchNews.dart';
// // import 'package:news/newsArt.dart';
// // import 'package:news/newscontainer.dart';
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool isLoading = true;
//   late NewsArt newsArt;

//   GetNews() async {
//     newsArt = await FetchNews.fetchNews();
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     GetNews();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//           controller: PageController(initialPage: 0),
//           scrollDirection: Axis.vertical,
//           onPageChanged: (value) {
//             setState(() {
//               isLoading = true;
//             });
//             GetNews();
//           },
//           itemBuilder: (context, index) {
//             return isLoading
//                 ? Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 : NewsContainer(
//                     imgUrl: newsArt.imgUrl,
//                     newsCnt: newsArt.newsCnt,
//                     newsHead: newsArt.newsHead,
//                     newsUrl: newsArt.newsUrl,
//                     newsDes: newsArt.newsDes,
//                   );
//           }),
//     );
//   }
// }

// lib/news/home.dart

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'fetchNews.dart';
import 'newsArt.dart';
import 'newscontainer.dart';
import 'detail.dart';

/// SearchDelegate filtering the global list
class NewsSearch extends SearchDelegate<NewsArt?> {
  final List<NewsArt> allArticles;
  NewsSearch(this.allArticles);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    final lower = query.toLowerCase();
    final results = allArticles.where((a) {
      return a.newsHead.toLowerCase().contains(lower) ||
          a.newsDes.toLowerCase().contains(lower);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) => NewsContainer(article: results[i]),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsArt> _indiaHeadlines = [];
  List<NewsArt> _globalHeadlines = [];
  String _selectedCategory = 'general';
  bool _isLoading = true;

  final List<String> _categories = [
    'general',
    'sports',
    'business',
    'entertainment',
    'science',
    'technology',
    'health',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAllNews();
  }

  Future<void> _fetchAllNews() async {
    setState(() => _isLoading = true);

    try {
      // Fetch India headlines with fallback
      _indiaHeadlines = await FetchNews.fetchIndiaHeadlines();

      // Fetch global by selected category
      _globalHeadlines =
          await FetchNews.fetchGlobalByCategory(_selectedCategory);
    } catch (e) {
      debugPrint('Error fetching news: $e');
      _indiaHeadlines = [];
      _globalHeadlines = [];
    }

    setState(() => _isLoading = false);
  }

  void _onCategoryTap(String category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    _fetchAllNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('NewsBlogAI'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search),
      //       onPressed: () => showSearch(
      //         context: context,
      //         delegate: NewsSearch(_globalHeadlines),
      //       ),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: _fetchAllNews,
      //     ),
      //   ],
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category filter bar
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (_, idx) {
                      final cat = _categories[idx];
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () => _onCategoryTap(cat),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              cat.toUpperCase(),
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Carousel title
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Trending in India',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Carousel of India headlines
                if (_indiaHeadlines.isEmpty)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No India headlines available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  CarouselSlider.builder(
                    itemCount: _indiaHeadlines.length,
                    itemBuilder: (context, index, _) {
                      final article = _indiaHeadlines[index];
                      return GestureDetector(
                        onTap: () {
                          if (article.newsUrl.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailViewScreen(newsUrl: article.newsUrl),
                              ),
                            );
                          }
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              article.imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image, size: 80)),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  article.newsHead,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                  ),

                // Global headlines section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Top Global News',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Vertical list of global headlines
                Expanded(
                  child: _globalHeadlines.isEmpty
                      ? const Center(child: Text('No global news'))
                      : ListView.builder(
                          itemCount: _globalHeadlines.length,
                          itemBuilder: (_, idx) =>
                              NewsContainer(article: _globalHeadlines[idx]),
                        ),
                ),
              ],
            ),
    );
  }
}
