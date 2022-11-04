import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_closachin/views/components/richtext/base_text.dart';
import 'package:insta_closachin/views/components/richtext/link_test.dart';

class RichTextWidget extends StatelessWidget {
  final TextStyle? styleForAll;
  final Iterable<BaseText> texts;
  const RichTextWidget({super.key, this.styleForAll, required this.texts});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map(
          (baseText) {
            if (baseText is LinkText) {
              return TextSpan(
                  text: baseText.text,
                  style: styleForAll?.merge(baseText.style),
                  recognizer: TapGestureRecognizer()
                    ..onTap = baseText.onTapped);
            } else {
              return TextSpan(
                text: baseText.text,
                style: styleForAll?.merge(baseText.style),
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
