import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/image_upload/typedefs/is_loading.dart';
import 'package:insta_closachin/state/posts/notifier/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) => DeletePostStateNotifier(),
);
