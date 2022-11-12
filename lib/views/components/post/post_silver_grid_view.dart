import 'package:flutter/material.dart';
import 'package:insta_closachin/state/posts/models/post.dart';
import 'package:insta_closachin/views/components/post/post_thumbnail_view.dart';
import 'package:insta_closachin/views/post_detail/post_detail_view.dart';

class PostSilverGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostSilverGridView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: posts.length,
        (context, index) {
          final post = posts.elementAt(index);
          return PostThumbnailView(
            post: post,
            onTapped: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailView(
                    post: post,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
