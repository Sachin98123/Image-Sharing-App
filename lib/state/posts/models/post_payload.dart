import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_closachin/state/image_upload/models/file_type.dart';
import 'package:insta_closachin/state/posts/models/post_key.dart';

import '../../post_settings/models/post_settings.dart';

@immutable
class Postpayload extends MapView<String, dynamic> {
  Postpayload({
    required String userId,
    required String message,
    required String thumbnailUrl,
    required String fileUrl,
    required FileType fileType,
    required String fileName,
    required double aspectRatio,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required Map<PostSetting, bool> postSettings,
  }) : super({
          PostKey.userId: userId,
          PostKey.message: message,
          PostKey.createdAt: FieldValue.serverTimestamp(),
          PostKey.thumbnailUrl: thumbnailUrl,
          PostKey.fileType: fileType.name,
          PostKey.fileUrl: fileUrl,
          PostKey.fileName: fileName,
          PostKey.aspectRatio: aspectRatio,
          PostKey.thumbnailStorageId: thumbnailStorageId,
          PostKey.originalFileStorageId: originalFileStorageId,
          PostKey.postSettings: {
            for (final postSetting in postSettings.entries)
              postSetting.key.storageKey: postSetting.value,
          }
        });
}
