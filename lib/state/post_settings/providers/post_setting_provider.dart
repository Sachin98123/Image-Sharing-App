import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/post_settings/models/post_settings.dart';
import 'package:insta_closachin/state/post_settings/notifiers/post_setting_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
