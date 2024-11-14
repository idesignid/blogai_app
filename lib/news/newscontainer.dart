import 'package:blog_app/news/detail.dart';
import 'package:flutter/material.dart';

class NewsContainer extends StatelessWidget {
  final String imgUrl;
  final String newsHead;
  final String newsDes;
  final String newsCnt;
  final String newsUrl;

  const NewsContainer({
    super.key,
    required this.imgUrl,
    required this.newsDes,
    required this.newsHead,
    required this.newsUrl,
    required this.newsCnt,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              height: 250, // Reduced height to prevent overflow
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: 'assets/ani.gif',
              image: imgUrl,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsHead.isNotEmpty && newsHead != '--'
                        ? newsHead.length > 80
                            ? '${newsHead.substring(0, 80)}...'
                            : newsHead
                        : newsHead,
                    style: const TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    newsCnt.isNotEmpty && newsCnt != '--'
                        ? newsCnt.length > 200
                            ? '${newsCnt.substring(0, 200)}...'
                            : newsCnt
                        : newsCnt,
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    newsDes.isNotEmpty && newsDes != '--'
                        ? newsDes.length > 400
                            ? '${newsDes.substring(0, 400)}...'
                            : newsDes
                        : newsDes,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         DetailViewScreen(newsUrl: newsUrl),
                    //   ),
                    // );
                  },
                  child: const Text('Read More'),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
