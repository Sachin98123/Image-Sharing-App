import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/auth_state_provider.dart';
import 'package:insta_closachin/state/comments/providers/delete_comment_provider.dart';
import 'package:insta_closachin/state/comments/providers/send_comment_provider.dart';
import 'package:insta_closachin/state/image_upload/provider/image_upload_provider.dart';
import 'package:insta_closachin/state/posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  final sendingComment = ref.watch(sendcommentProvider);
  final isDeletingComment = ref.watch(deleteCommentProvider);
  final deletingPost = ref.watch(deletePostProvider);
  return authState.isLoading ||
      isUploadingImage ||
      sendingComment ||
      isDeletingComment ||
      deletingPost;
});
