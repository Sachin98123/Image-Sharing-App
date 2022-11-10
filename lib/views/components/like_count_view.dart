import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/likes/providers/post_like_count_provider.dart';
import 'package:insta_closachin/state/posts/typedef/post_id.dart';
import 'package:insta_closachin/views/components/animations/small_error_animation_view.dart';
import 'package:insta_closachin/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    required this.postId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikeCountProvider(postId));
    return likesCount.when(
      data: (int likesCount) {
        // if (likesCount == 0) {
        //   return const Text("be the  First one to like the post ");
        // }
        final personPeople = likesCount == 1 ? Strings.person : Strings.people;
        final likesText = "$likesCount $personPeople ${Strings.likedThis}";
        return Text(likesText);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationVIew();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
