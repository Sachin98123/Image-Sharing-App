import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/constants/firebase_collection_name.dart';
import 'package:insta_closachin/state/constants/firebase_field_names.dart';

import '../models/post.dart';
import '../typedef/search_term.dart';

final postBySearchTermProvider =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>(
  (ref, SearchTerm searchTerm) {
    final controller = StreamController<Iterable<Post>>();
    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs
          .map(
            (doc) => Post(
              json: doc.data(),
              postId: doc.id,
            ),
          )
          .where(
            (post) => post.message.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ),
          );
      controller.sink.add(posts);
    });
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  },
);
