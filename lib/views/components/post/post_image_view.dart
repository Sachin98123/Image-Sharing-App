import 'package:flutter/material.dart';
import 'package:insta_closachin/state/posts/models/post.dart';

class PostImageView extends StatelessWidget {
  final Post post;
  const PostImageView({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: Image.network(
        post.fileUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
