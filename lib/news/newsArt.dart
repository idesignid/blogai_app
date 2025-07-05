// class NewsArt{
//   String imgUrl;
//   String newsHead;
//   String newsDes;
//   String newsCnt;
//   String newsUrl;
//   NewsArt({
//     required this.imgUrl,
//     required this.newsHead,
//     required this.newsDes,
//     required this.newsCnt,
//     required this.newsUrl,

// });

//   static NewsArt fromAPItoApp(Map<String,dynamic> article){
//     return NewsArt(imgUrl: article['urlToImage'] ?? 'https://images.pexels.com/photos/935979/pexels-photo-935979.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',

//         newsHead: article['title']??'--',
//         newsDes: article['description']??'--',
//         newsCnt: article['content']??'--',
//         newsUrl: article['url'] ?? 'https://news.google.com/home?hl=en-IN&gl=IN&ceid=IN:en');
//   }

// }

class NewsArt {
  final String imgUrl;
  final String newsHead;
  final String newsDes;
  final String newsUrl;
  final String? source;

  NewsArt({
    required this.imgUrl,
    required this.newsHead,
    required this.newsDes,
    required this.newsUrl,
    this.source,
  });

  factory NewsArt.fromJson(Map<String, dynamic> json) {
    return NewsArt(
      imgUrl: json['urlToImage'] ?? '',
      newsHead: json['title'] ?? '',
      newsDes: json['description'] ?? '',
      newsUrl: json['url'] ?? '',
      source: json['source']?['name'],
    );
  }
}
