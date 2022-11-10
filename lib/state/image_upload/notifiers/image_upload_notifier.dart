import 'dart:io' show File;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/constants/firebase_collection_name.dart';
import 'package:insta_closachin/state/image_upload/constants/constants.dart';
import 'package:insta_closachin/state/image_upload/exception/couldnot_build_thumbnail.dart';
import 'package:insta_closachin/state/image_upload/extension/get_collection_name_from_file_type.dart';
import 'package:insta_closachin/state/image_upload/extension/get_image_data_aspect_ratio.dart';
import 'package:insta_closachin/state/image_upload/models/file_type.dart';
import 'package:insta_closachin/state/image_upload/typedefs/is_loading.dart';
import 'package:insta_closachin/state/posts/models/post_payload.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../post_settings/models/post_settings.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  ImageUploadNotifier() : super(false);
  set isLoading(bool value) => state = value;
  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required String userId,
  }) async {
    isLoading = true;
    late Uint8List thumbnailUnit8List;
    switch (fileType) {
      case FileType.images:
        //create a thumbnail out of the file
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          return false;
        }
        //create thumbnail
        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUnit8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.videos:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxheight,
          quality: Constants.videoThumbnailQuality,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUnit8List = thumb;
        }
        break;
    }

    //calculate the aspect ratio
    final thumbnailAspectRatio = await thumbnailUnit8List.getAspectRatio();

    //calculate refrences
    final fileName = const Uuid().v4();

    //create refrences to the thumbnail and the image itself

    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //upload The Thumbnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUnit8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //upload the original image
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalFileStorageId = originalFileUploadTask.ref.name;

      //upload the post itself
      final postPayload = Postpayload(
          userId: userId,
          message: message,
          thumbnailUrl: await thumbnailRef.getDownloadURL(),
          fileUrl: await originalFileRef.getDownloadURL(),
          fileType: fileType,
          fileName: fileName,
          aspectRatio: thumbnailAspectRatio,
          thumbnailStorageId: thumbnailStorageId,
          originalFileStorageId: originalFileStorageId,
          postSettings: postSettings);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayload);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
