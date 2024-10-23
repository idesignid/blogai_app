import 'dart:math';

import 'package:blog_app/chatai/chatai.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Main BlogPage widget
class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> with WidgetsBindingObserver {
  int _currentIndex = 0; // To track the selected bottom navigation index
  List<Widget> _pages = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    _pages = [
      BlogScreen(searchController: searchController), // Blog screen with search
      ChatAiScreen(), // ChatAi screen (implement this later)
    ];
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer on dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    BlogSearchDelegate(searchController: searchController),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                Navigator.push(context, AddNewBlogPage.route());
              });
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: _pages[_currentIndex], // Display the current selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'ChatAi',
          ),
        ],
      ),
    );
  }
}

// Blog Screen logic with BlocConsumer for managing state and showing the list of blogs

class BlogScreen extends StatefulWidget {
  final TextEditingController searchController;

  const BlogScreen({super.key, required this.searchController});

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<Blog> _filteredBlogs = [];

  // Function to generate random colors using a deterministic method
  Color generateColor(int index) {
    final random = Random(index); // Seed with the index for consistency
    // Generate random hue, saturation, and lightness values
    final hue = random.nextDouble() * 360;
    return HSLColor.fromAHSL(1, hue, 0.7, 0.6).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is BlogFailure) {
          showSnackBar(context, state.error);
        }
      },
      builder: (context, state) {
        if (state is BlogLoading) {
          return const Loader();
        }
        if (state is BlogsDisplaySuccess) {
          final blogs = state.blogs;

          // Apply filtering based on the search term
          _filteredBlogs = blogs
              .where((blog) => blog.title
                  .toLowerCase()
                  .contains(widget.searchController.text.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: _filteredBlogs.length,
            itemBuilder: (context, index) {
              final blog = _filteredBlogs[index];
              return BlogCard(
                blog: blog,
                color: generateColor(index), // Generate color based on index
              );
            },
          );
        }
        return const SizedBox(); // Display an empty widget when there's no data
      },
    );
  }
}

// Search Delegate for Blog Search functionality
class BlogSearchDelegate extends SearchDelegate {
  final TextEditingController searchController;

  BlogSearchDelegate({required this.searchController});

  @override
  String get searchFieldLabel => 'Search Blogs';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchController.clear();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

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
