// import 'dart:math';

// import 'package:blog_app/chatai/chatai.dart';
// import 'package:blog_app/core/common/widgets/loader.dart';
// import 'package:blog_app/core/utils/show_snackbar.dart';
// import 'package:blog_app/features/blog/domain/entities/blog.dart';
// import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
// import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
// import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
// import 'package:blog_app/news/news.dart';
// import 'package:blog_app/news/report.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'news_screen.dart'; // Import NewsScreen

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class BlogPage extends StatefulWidget {
//   static route() => MaterialPageRoute(
//         builder: (context) => const BlogPage(),
//       );
//   const BlogPage({super.key});

//   @override
//   State<BlogPage> createState() => _BlogPageState();
// }

// class _BlogPageState extends State<BlogPage> with WidgetsBindingObserver {
//   int _currentIndex = 0; // Track the selected bottom navigation index
//   late List<Widget> _pages;
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
//     _pages = [
//       BlogScreen(searchController: searchController), // Blog screen with search
//       ChatAiScreen(), // ChatAi screen
//       const NewsApp(), // News screen
//       const ReportScreen(), // Report screen for inappropriate blogs
//     ];
//     context.read<BlogBloc>().add(BlogFetchAllBlogs());
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this); // Remove observer on dispose
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blog App'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate:
//                     BlogSearchDelegate(searchController: searchController),
//               );
//             },
//           ),
//           IconButton(
//             onPressed: () {
//               Future.delayed(const Duration(milliseconds: 100), () {
//                 Navigator.push(context, AddNewBlogPage.route());
//               });
//             },
//             icon: const Icon(CupertinoIcons.add_circled),
//           ),
//         ],
//       ),
//       body: _pages[_currentIndex], // Display the currently selected page
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index; // Update the current index on tap
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.article),
//             label: 'Blogs',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'ChatAi',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.newspaper),
//             label: 'News',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.report),
//             label: 'Report',
//           ),
//         ],
//         selectedItemColor: Colors.blue, // Set color for selected item
//         unselectedItemColor: Colors.black, // Set color for unselected items
//         showUnselectedLabels: true, // Ensure all labels are shown
//       ),
//     );
//   }
// }

// // Blog Screen logic with BlocConsumer for managing state and showing the list of blogs

// class BlogScreen extends StatefulWidget {
//   final TextEditingController searchController;

//   const BlogScreen({super.key, required this.searchController});

//   @override
//   _BlogScreenState createState() => _BlogScreenState();
// }

// class _BlogScreenState extends State<BlogScreen> {
//   List<Blog> _filteredBlogs = [];

//   // Function to generate random colors using a deterministic method
//   Color generateColor(int index) {
//     final random = Random(index); // Seed with the index for consistency
//     // Generate random hue, saturation, and lightness values
//     final hue = random.nextDouble() * 360;
//     return HSLColor.fromAHSL(1, hue, 0.7, 0.6).toColor();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<BlogBloc, BlogState>(
//       listener: (context, state) {
//         if (state is BlogFailure) {
//           showSnackBar(context, state.error);
//         }
//       },
//       builder: (context, state) {
//         if (state is BlogLoading) {
//           return const Loader();
//         }
//         if (state is BlogsDisplaySuccess) {
//           final blogs = state.blogs;

//           // Apply filtering based on the search term
//           _filteredBlogs = blogs
//               .where((blog) => blog.title
//                   .toLowerCase()
//                   .contains(widget.searchController.text.toLowerCase()))
//               .toList();

//           return ListView.builder(
//             itemCount: _filteredBlogs.length,
//             itemBuilder: (context, index) {
//               final blog = _filteredBlogs[index];
//               return BlogCard(
//                 blog: blog,
//                 color: generateColor(index), // Generate color based on index
//               );
//             },
//           );
//         }
//         return const SizedBox(); // Display an empty widget when there's no data
//       },
//     );
//   }
// }

// // Search Delegate for Blog Search functionality
// class BlogSearchDelegate extends SearchDelegate {
//   final TextEditingController searchController;

//   BlogSearchDelegate({required this.searchController});

//   @override
//   String get searchFieldLabel => 'Search Blogs';

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//           searchController.clear();
//         },
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     searchController.text = query;
//     return BlogScreen(searchController: searchController);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     searchController.text = query;
//     return BlogScreen(searchController: searchController);
//   }
// }
// lib/features/blog/presentation/pages/blog_page.dart

import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:blog_app/chatai/chatai.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/news/news.dart';
import 'package:blog_app/news/report.dart';
import 'package:blog_app/core/theme/app_pallete.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  late List<Widget> _pages;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pages = [
      BlogScreen(searchController: searchController),
      ChatAiScreen(),
      const NewsApp(),
      const ReportScreen(),
    ];
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        title: Text(
          'Blog App',
          style: TextStyle(color: AppPallete.whiteColor),
        ),
        iconTheme: IconThemeData(color: AppPallete.whiteColor),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
              AppPallete.isLight ? Icons.dark_mode : Icons.light_mode,
              color: AppPallete.whiteColor,
            ),
            onPressed: () => setState(() {
              AppPallete.toggleTheme();
            }),
          ),
          // Search
          IconButton(
            icon: Icon(Icons.search, color: AppPallete.whiteColor),
            onPressed: () => showSearch(
              context: context,
              delegate: BlogSearchDelegate(searchController: searchController),
            ),
          ),
          // Add new blog
          IconButton(
            icon:
                Icon(CupertinoIcons.add_circled, color: AppPallete.whiteColor),
            onPressed: () => Future.delayed(
              const Duration(milliseconds: 100),
              () => Navigator.push(context, AddNewBlogPage.route()),
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppPallete.backgroundColor,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Blogs'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'ChatAi'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
        ],
        selectedItemColor: AppPallete.gradient1,
        unselectedItemColor: AppPallete.greyColor,
        showUnselectedLabels: true,
      ),
    );
  }
}

class BlogScreen extends StatefulWidget {
  final TextEditingController searchController;
  const BlogScreen({super.key, required this.searchController});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Blog> _filteredBlogs = [];

  Color generateColor(int index) {
    final rnd = Random(index);
    // fully random hue, 0–360°
    final hue = rnd.nextDouble() * 360;

    // keep saturation in a mid‑range (40–60%) for softness
    final saturation = 0.4 + rnd.nextDouble() * 0.2;

    // adjust lightness based on theme:
    // • light mode: lighter pastels (70–80%)
// • dark mode: medium tones (40–50%)
    final lightness = AppPallete.isLight
        ? 0.4 + rnd.nextDouble() * 0.1
        : 0.6 + rnd.nextDouble() * 0.1;

    return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailure) showSnackBar(context, state.error);
      },
      builder: (context, state) {
        if (state is BlogLoading) return const Loader();
        if (state is BlogsDisplaySuccess) {
          final blogs = state.blogs.where((b) {
            return b.title
                .toLowerCase()
                .contains(widget.searchController.text.toLowerCase());
          }).toList();
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (_, i) => BlogCard(
              blog: blogs[i],
              color: generateColor(i),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class BlogSearchDelegate extends SearchDelegate {
  final TextEditingController searchController;
  BlogSearchDelegate({required this.searchController});

  @override
  String get searchFieldLabel => 'Search Blogs';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            searchController.clear();
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    searchController.text = query;
    return BlogScreen(searchController: searchController);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchController.text = query;
    return BlogScreen(searchController: searchController);
  }
}
