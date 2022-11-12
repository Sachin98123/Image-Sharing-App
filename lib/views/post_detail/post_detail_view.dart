import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/enum/date_sorting.dart';
import 'package:insta_closachin/state/comments/models/post_comment_requests.dart';
import 'package:insta_closachin/state/posts/models/post.dart';
import 'package:insta_closachin/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:insta_closachin/state/posts/providers/delete_post_provider.dart';
import 'package:insta_closachin/state/posts/providers/specific_post_with_comment_provider.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/animations/small_error_animation_view.dart';
import 'package:insta_closachin/views/components/comment/compact_comment_column.dart';
import 'package:insta_closachin/views/components/dialogs/alert_dialog_model.dart';
import 'package:insta_closachin/views/components/dialogs/delete_dialog.dart';
import 'package:insta_closachin/views/components/like_button.dart';
import 'package:insta_closachin/views/components/like_count_view.dart';
import 'package:insta_closachin/views/components/post/post_date_view.dart';
import 'package:insta_closachin/views/components/post/post_display_and_message_view.dart';
import 'package:insta_closachin/views/components/post/post_image_or_video_view.dart';
import 'package:insta_closachin/views/constants/strings.dart';
import 'package:insta_closachin/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailView({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    //get the actual post together with its comments
    final postWithComments = ref.watch(
      specificPostWithCommentProvider(
        request,
      ),
    );

    //can we delete this post ?
    final canDeletePost = ref.watch(
      canCurrentuserDeletePostProvider(
        widget.post,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
        ),
        actions: [
          //share button is always present
          postWithComments.when(
            data: (postWithComments) {
              return IconButton(
                onPressed: () {
                  final url = postWithComments.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
                icon: const Icon(Icons.share),
              );
            },
            error: (error, stackTrace) {
              return const SmallErrorAnimationVIew();
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          //delete button or no delete button if user cannot delete
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context)
                    .then(
                      (shouldDelete) => shouldDelete ?? false,
                    );
                if (shouldDeletePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PostImageOrVideoView(
                    post: postWithComments.post,
                  ),
                  //like and comment button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (postWithComments.post.allowLikes)
                        LikeButton(
                          postId: postId,
                        ),
                      //comment button if comment is allowed
                      if (postWithComments.post.allowComments)
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PostCommentsView(
                                  postId: postId,
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
                  //post details (show divider at bottom )
                  PostDisplayNameAndMessageView(
                    post: postWithComments.post,
                  ),
                  PostDateView(
                    dateTime: postWithComments.post.createdAt,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Divider(
                      color: Colors.white70,
                    ),
                  ),
                  //comments
                  CompactCommentColumn(
                    comments: postWithComments.comments,
                  ),
                  //display like count
                  if (postWithComments.post.allowLikes)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          LikesCountView(
                            postId: postId,
                          ),
                        ],
                      ),
                    ),
                  //add spacing to the buttom of the screen
                  const SizedBox(
                    height: 100,
                  ),
                ]),
          );
        },
        error: (error, stackTrace) {
          return const ErrorContentAnimationView();
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
