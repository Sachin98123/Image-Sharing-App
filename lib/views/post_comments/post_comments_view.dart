import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/user_id_provider.dart';
import 'package:insta_closachin/state/comments/models/post_comment_requests.dart';
import 'package:insta_closachin/state/comments/providers/post_comment_providers.dart';
import 'package:insta_closachin/state/comments/providers/send_comment_provider.dart';
import 'package:insta_closachin/state/posts/typedef/post_id.dart';
import 'package:insta_closachin/views/components/animations/empty_content_with_animation_view.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/animations/loading_animation_view.dart';
import 'package:insta_closachin/views/components/comment/comment_tile.dart';
import 'package:insta_closachin/views/extensions/dismiss_keyboard.dart';

import '../constants/strings.dart';

class PostCommentsView extends HookConsumerWidget {
  final PostId postId;
  const PostCommentsView({
    required this.postId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    final hasText = useState(false);
    final request = useState(
      RequestForPostAndComments(
        postId: postId,
      ),
    );
    final comments = ref.watch(
      postCommentProvider(request.value),
    );

    //enable post button when text is entered in the textfield
    useEffect(
      () {
        commentController.addListener(() {
          hasText.value = commentController.text.isNotEmpty;
        });
        return () {};
      },
      [commentController],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.comments),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () {
                    _submitCommentWithController(
                      commentController,
                      ref,
                    );
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: comments.when(data: (comments) {
                if (comments.isEmpty) {
                  return const SingleChildScrollView(
                    child: EmptyContentsWithTextAnimationView(
                        text: Strings.noCommentsYet),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () {
                    ref.refresh(
                      postCommentProvider(request.value),
                    );
                    return Future.delayed(
                      const Duration(seconds: 1),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: comments.length,
                    itemBuilder: ((context, index) {
                      final comment = comments.elementAt(index);
                      return CommentTile(comment: comment);
                    }),
                  ),
                );
              }, error: (error, stackTrace) {
                return const ErrorContentAnimationView();
              }, loading: () {
                return const LoadingAnimationView();
              }),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: commentController,
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(
                          commentController,
                          ref,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.read(sendcommentProvider.notifier).sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );
    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
