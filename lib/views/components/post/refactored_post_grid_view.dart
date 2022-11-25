import 'package:flutter/material.dart';
import 'package:insta_closachin/views/components/like_button.dart';
import 'package:insta_closachin/views/components/post/post_display_and_message_view.dart';
import 'package:insta_closachin/views/components/post/post_thumbnail_view.dart';
import 'package:insta_closachin/views/post_comments/post_comments_view.dart';
import 'package:insta_closachin/views/post_detail/post_detail_view.dart';

import '../../../state/posts/models/post.dart';

class RefactoredPostGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const RefactoredPostGridView({
    super.key,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
          final post = posts.elementAt(index);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostDisplayNameAndMessageView(
                post: post,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: PostThumbnailView(
                  post: post,
                  onTapped: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailView(
                          post: post,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (post.allowLikes)
                      LikeButton(
                        postId: post.postId,
                      ),
                    //comment button if comment is allowed
                    if (post.allowComments)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostCommentsView(
                                postId: post.postId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }, childCount: posts.length)),
      ],
    );
  }
}
