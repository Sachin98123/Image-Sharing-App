import 'package:flutter/cupertino.dart';

extension DismissKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
