import 'package:flutter/material.dart';
import 'package:insta_closachin/state/comments/models/comment.dart';
import 'package:insta_closachin/views/components/comment/compact_comment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommentColumn({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 8,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map(
          (comment) {
            return CompactCommentTile(
              comment: comment,
            );
          },
        ).toList(),
      ),
    );
  }
}
