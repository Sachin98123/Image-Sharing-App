import 'dart:collection';

import 'package:insta_closachin/state/constants/firebase_field_names.dart';
import 'package:insta_closachin/state/posts/typedef/user_id.dart';

import '../../posts/typedef/post_id.dart';

class Like extends MapView<String, String> {
  final PostId postId;
  final UserId likedBy;
  final DateTime date;

  Like({
    required this.postId,
    required this.likedBy,
    required this.date,
  }) : super({
          FirebaseFieldName.userId: likedBy,
          FirebaseFieldName.date: date.toIso8601String(),
          FirebaseFieldName.postId: postId,
        });
}
