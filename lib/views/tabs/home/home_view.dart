import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/posts/providers/all_post_provider.dart';
import 'package:insta_closachin/views/components/animations/empty_content_with_animation_view.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/animations/loading_animation_view.dart';
import 'package:insta_closachin/views/components/post/refactored_post_grid_view.dart';
import 'package:insta_closachin/views/constants/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostsProvider);
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(allPostsProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
      child: posts.when(data: (posts) {
        if (posts.isEmpty) {
          return const EmptyContentsWithTextAnimationView(
            text: Strings.noPostsAvailable,
          );
        } else {
          //TODO : i have used Refactored post grid view here so reverse if it dont work out
          return RefactoredPostGridView(
            posts: posts,
          );
        }
      }, error: (error, stacktrace) {
        return const ErrorContentAnimationView();
      }, loading: () {
        return const LoadingAnimationView();
      }),
    );
  }
}
