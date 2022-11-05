import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/providers/auth_state_provider.dart';

import '../../posts/typedef/user_id.dart';

final userIdProvider = Provider<UserId?>(
  ((ref) => ref.watch(authStateProvider).userId),
);
