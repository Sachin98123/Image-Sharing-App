import 'package:flutter/material.dart';
import 'package:insta_closachin/state/image_upload/models/file_type.dart';
import 'package:insta_closachin/views/components/post/post_image_view.dart';
import 'package:insta_closachin/views/components/post/post_video_view.dart';

import '../../../state/posts/models/post.dart';

class PostImageOrVideoView extends StatelessWidget {
  final Post post;
  const PostImageOrVideoView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    switch (post.fileType) {
      case FileType.images:
        return PostImageView(post: post);
      case FileType.videos:
        return PostVideoView(post: post);
      default:
        return const Text(
          "this is neither image not video(handle exception first in fileType file",
        );
    }
  }
}
