import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/notifier/auth_state_notifier.dart';

import '../model/auth_state.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
