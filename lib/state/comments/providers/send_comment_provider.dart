import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/comments/notifiers/send_comment_notifiers.dart';
import 'package:insta_closachin/state/image_upload/typedefs/is_loading.dart';

final sendcommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (ref) => SendCommentNotifier(),
);
