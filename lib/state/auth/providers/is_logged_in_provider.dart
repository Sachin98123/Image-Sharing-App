import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_closachin/state/auth/model/auth_result.dart';
import 'package:insta_closachin/state/auth/providers/auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.result == AuthResult.success;
});
