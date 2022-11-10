import 'package:insta_closachin/state/comments/models/comment.dart';
import 'package:insta_closachin/state/comments/models/post_comment_requests.dart';

import '../../../enum/date_sorting.dart';

extension Sorting on Iterable<Comment> {
  Iterable<Comment> applySortingFrom(RequestForPostAndComments request) {
    if (request.sortByCreatedAt) {
      final sortedDocuments = toList()
        ..sort((a, b) {
          switch (request.dateSorting) {
            case DateSorting.newstOnTop:
              return b.createdAt.compareTo(a.createdAt);
            case DateSorting.oldestOnTop:
              return a.createdAt.compareTo(b.createdAt);
          }
        });
      return sortedDocuments;
    } else {
      return this;
    }
  }
}
