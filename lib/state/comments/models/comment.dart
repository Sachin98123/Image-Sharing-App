import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_closachin/state/comments/typedef/comment.dart';
import 'package:insta_closachin/state/constants/firebase_field_names.dart';
import 'package:insta_closachin/state/posts/typedef/post_id.dart';
import 'package:insta_closachin/state/posts/typedef/user_id.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId;
  final PostId onPostId;

  Comment(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFieldName.userId],
        onPostId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          fromUserId == other.fromUserId &&
          onPostId == other.onPostId;

  @override
  int get hashCode => Object.hashAll(
        [
          id,
          comment,
          fromUserId,
          onPostId,
        ],
      );
}
