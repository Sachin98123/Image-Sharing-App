import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:insta_closachin/state/constants/firebase_field_names.dart';

@immutable
class CommnetPayload extends MapView<String, dynamic> {
  CommnetPayload({
    required String fromUserId,
    required String onPostId,
    required String comment,
  }) : super(
          {
            FirebaseFieldName.userId: fromUserId,
            FirebaseFieldName.postId: onPostId,
            FirebaseFieldName.comment: comment,
            FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          },
        );
}
