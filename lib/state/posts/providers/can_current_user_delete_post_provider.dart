import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/user_id_provider.dart';

import '../models/post.dart';

final canCurrentuserDeletePostProvider =
    StreamProvider.autoDispose.family<bool, Post>((ref, Post post) async* {
  final userId = ref.watch(userIdProvider);
  yield userId == post.userId;
});
