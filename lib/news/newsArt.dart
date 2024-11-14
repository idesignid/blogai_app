class NewsArt{
  String imgUrl;
  String newsHead;
  String newsDes;
  String newsCnt;
  String newsUrl;
  NewsArt({
    required this.imgUrl,
    required this.newsHead,
    required this.newsDes,
    required this.newsCnt,
    required this.newsUrl,


});

  static NewsArt fromAPItoApp(Map<String,dynamic> article){
    return NewsArt(imgUrl: article['urlToImage'] ?? 'https://images.pexels.com/photos/935979/pexels-photo-935979.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',

        newsHead: article['title']??'--',
        newsDes: article['description']??'--',
        newsCnt: article['content']??'--',
        newsUrl: article['url'] ?? 'https://news.google.com/home?hl=en-IN&gl=IN&ceid=IN:en');
  }

}