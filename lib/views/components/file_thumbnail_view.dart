import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/image_upload/models/thumbnail_request.dart';
import 'package:insta_closachin/state/image_upload/provider/thumbnail_provider.dart';
import 'package:insta_closachin/views/components/animations/error_animation_view.dart';
import 'package:insta_closachin/views/components/animations/loading_animation_view.dart';

class FileThumbnailView extends ConsumerWidget {
  final ThumbnailRequest thumbnailRequest;
  const FileThumbnailView({
    required this.thumbnailRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //send request to provider
    final thumbnail = ref.watch(thumbnailProvider(
      thumbnailRequest,
    ));
    return thumbnail.when(
      data: (imageWithAspectRatio) {
        return AspectRatio(
          aspectRatio: imageWithAspectRatio.aspectRatio,
          child: imageWithAspectRatio.image,
        );
      },
      error: (error, stackTrace) {
        return const ErrorContentAnimationView();
      },
      loading: () {
        return const LoadingAnimationView();
      },
    );
  }
}
