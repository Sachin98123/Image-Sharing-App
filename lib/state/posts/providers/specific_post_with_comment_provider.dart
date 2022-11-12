import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/comments/extensions/comment_soringby_request.dart';
import 'package:insta_closachin/state/comments/models/comment.dart';
import 'package:insta_closachin/state/comments/models/post_comment_requests.dart';
import 'package:insta_closachin/state/comments/models/post_with_comments.dart';
import 'package:insta_closachin/state/constants/firebase_collection_name.dart';
import 'package:insta_closachin/state/constants/firebase_field_names.dart';
import 'package:insta_closachin/state/posts/models/post.dart';

final specificPostWithCommentProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>(
  (ref, RequestForPostAndComments request) {
    final controller = StreamController<PostWithComments>();
    Post? post;
    Iterable<Comment>? comments;
    void notify() {
      final loacalPost = post;
      if (post == null) {
        return;
      }
      final outputComments = (comments ?? []).applySortingFrom(request);
      final result = PostWithComments(
        post: loacalPost!,
        //TODO: i have done this explicitly so maybe improve later
        comments: outputComments,
      );
      controller.sink.add(result);
    }

    //watch changes to the post
    final postSub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .where(FieldPath.documentId, isEqualTo: request.postId)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        post == null;
        comments = null;
        notify();
        return;
      }
      final doc = snapshot.docs.first;
      if (doc.metadata.hasPendingWrites) {
        return;
      }
      post = Post(
        postId: doc.id,
        json: doc.data(),
      );
      notify();
    });
    //watch changes to the comments
    final commentsQuery = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.comments,
        )
        .where(
          FirebaseFieldName.postId,
          isEqualTo: request.postId,
        )
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        );
    final limitedCommentsQuery = request.limit != null
        ? commentsQuery.limit(request.limit!)
        : commentsQuery;

    final commentsSub = limitedCommentsQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where(
              (doc) => !doc.metadata.hasPendingWrites,
            )
            .map(
              (doc) => Comment(
                doc.data(),
                id: doc.id,
              ),
            );
        notify();
      },
    );
    ref.onDispose(() {
      postSub.cancel();
      commentsSub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
