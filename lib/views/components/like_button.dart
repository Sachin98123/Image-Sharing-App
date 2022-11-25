import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/user_id_provider.dart';
import 'package:insta_closachin/state/likes/providers/has_liked_post_provider.dart';
import 'package:insta_closachin/state/likes/providers/like_dislike_post_provider.dart';
import 'package:insta_closachin/state/likes/providers/like_dislike_request.dart';
import 'package:insta_closachin/state/posts/typedef/post_id.dart';
import 'package:insta_closachin/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;

  const LikeButton({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));

    return hasLiked.when(data: (hasLiked) {
      return IconButton(
        icon: hasLiked
            ? const FaIcon(
                FontAwesomeIcons.solidHeart,
                color: Colors.red,
              )
            : const FaIcon(
                FontAwesomeIcons.heart,
              ),
        onPressed: () {
          final userId = ref.read(userIdProvider);
          if (userId == null) {
            return;
          }
          final likeRequest = LikeDislikeRequest(
            postId: postId,
            likedBy: userId,
          );
          ref.read(
            likeDislikePostProvider(
              likeRequest,
            ),
            //TODO    here is the mistake if anything heppens to like button
          );
        },
      );
    }, error: (error, stackTrace) {
      return const SmallErrorAnimationVIew();
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
