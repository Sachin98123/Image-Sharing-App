import 'package:flutter/material.dart';
import 'package:insta_closachin/state/posts/models/post.dart';

class PostThumbnailView extends StatelessWidget {
  final Post post;
  final VoidCallback onTapped;
  const PostThumbnailView({
    super.key,
    required this.post,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapped,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.45,
          child: Image.network(
            post.thumbnailUrl,
            fit: BoxFit.cover,
          ),
        ));
  }
}
