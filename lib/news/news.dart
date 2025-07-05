// import 'package:blog_app/news/home.dart';
// import 'package:blog_app/news/splash.dart';
// import 'package:flutter/material.dart';
// // import 'package:news/home.dart';
// // import 'package:news/splash.dart';

// class NewsApp extends StatefulWidget {
//   const NewsApp({super.key});

//   @override
//   State<NewsApp> createState() => _NewsAppState();
// }

// class _NewsAppState extends State<NewsApp> {
//   bool showingSplash = true;

//   void loadHome() {
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         showingSplash = false;
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadHome();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'News',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: showingSplash ? const SplashScreen() : const HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'home.dart';
import 'splash.dart';
import 'report.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewsBlogAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: _showSplash ? const SplashScreen() : const HomeScreen(),
      routes: {'/report': (_) => const ReportScreen()},
    );
  }
}
