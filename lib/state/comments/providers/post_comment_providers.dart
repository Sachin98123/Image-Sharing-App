import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/comments/extensions/comment_soringby_request.dart';
import 'package:insta_closachin/state/comments/models/comment.dart';
import 'package:insta_closachin/state/constants/firebase_collection_name.dart';
import 'package:insta_closachin/state/constants/firebase_field_names.dart';

import '../models/post_comment_requests.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<Iterable<Comment>>();
  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.comments)
      .where(FirebaseFieldName.postId, isEqualTo: request.postId)
      .snapshots()
      .listen(
    (snapshot) {
      final documents = snapshot.docs;
      final limitedDocuments =
          request.limit != null ? documents.take(request.limit!) : documents;
      final comments = limitedDocuments
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map(
            (document) => Comment(
              id: document.id,
              document.data(),
            ),
          );
      final result = comments.applySortingFrom(request);
      controller.sink.add(result);
    },
  );
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});
