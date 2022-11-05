import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/providers/user_post_provider.dart';
import 'package:insta_closachin/views/components/animations/empty_content_with_animation_view.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/animations/loading_animation_view.dart';
import 'package:insta_closachin/views/components/post/post_grid_view.dart';

class UserPostView extends ConsumerWidget {
  const UserPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostProvider);
    return RefreshIndicator(
        child: posts.when(data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
                text: "You have not Posts ");
          } else {
            return PostGridView(posts: posts);
          }
        }, error: (error, stackTrace) {
          return const ErrorContentAnimationView();
        }, loading: () {
          return const LoadingAnimationView();
        }),
        onRefresh: () {
          ref.refresh(userPostProvider);
          return Future.delayed(const Duration(seconds: 1));
        });
  }
}
