import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section flexibly occupies available space
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Horizontal list of topic chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.topics
                          .map(
                            (topic) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Chip(label: Text(topic)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Blog title, limited to 2 lines
                  Text(
                    blog.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Reading time pinned to the bottom
            Text(
              '${calculateReadingTime(blog.content)} min read',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
