import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/posts/providers/post_by_search_term_provider.dart';
import 'package:insta_closachin/views/components/animations/data_not_found_animation_view.dart';
import 'package:insta_closachin/views/components/animations/empty_content_with_animation_view.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/post/post_silver_grid_view.dart';
import 'package:insta_closachin/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final String searchTerm;
  const SearchGridView({required this.searchTerm, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentsWithTextAnimationView(
          text: Strings.enterYourSearchTermHere,
        ),
      );
    }
    final posts = ref.watch(
      postBySearchTermProvider(searchTerm),
    );
    return posts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostSilverGridView(
            posts: posts,
          );
        }
      },
      error: (error, stackTrace) {
        return const ErrorContentAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
