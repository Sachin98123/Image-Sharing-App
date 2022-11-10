import 'package:insta_closachin/state/image_upload/models/file_type.dart';

extension CollectionName on FileType {
  String get collectionName {
    switch (this) {
      case FileType.images:
        return 'images';
      case FileType.videos:
        return 'videos';
    }
  }
}
