import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/auth_state_provider.dart';
import 'package:insta_closachin/state/image_upload/provider/image_upload_provider.dart';

final isLoadingProvider = Provider((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  return authState.isLoading || isUploadingImage;
});
