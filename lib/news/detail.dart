// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class DetailViewScreen extends StatefulWidget {
//   final String newsUrl;

//   DetailViewScreen({super.key, required this.newsUrl});

//   @override
//   State<DetailViewScreen> createState() => _DetailViewScreenState();
// }

// class _DetailViewScreenState extends State<DetailViewScreen> {
//   final Completer<WebViewController> controller =
//       Completer<WebViewController>();

//   @override
//   void initState() {
//     super.initState();
//     // Hybrid composition for Android
//     if (Platform.isAndroid) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News APP'),
//       ),
//       body: WebView(
//         initialUrl: widget.newsUrl,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           controller.complete(webViewController);
//         },
//       ),
//     );
//   }
// }
