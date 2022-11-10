import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/constants/firebase_collection_name.dart';
import 'package:insta_closachin/state/constants/firebase_field_names.dart';
import 'package:insta_closachin/state/posts/typedef/post_id.dart';

final postLikeCountProvider = StreamProvider.family.autoDispose<int, PostId>((
  ref,
  PostId postId,
) {
  final controller = StreamController<int>.broadcast();
  controller.onListen = () {
    //initial case when nobody liked the post
    controller.sink.add(0);
  };
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.likes)
      .where(
        FirebaseFieldName.postId,
        isEqualTo: postId,
      )
      .snapshots()
      .listen((snapshot) {
    controller.sink.add(snapshot.docs.length);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
