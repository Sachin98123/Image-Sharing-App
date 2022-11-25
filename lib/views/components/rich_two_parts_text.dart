import 'package:flutter/material.dart';
import 'package:image/image.dart';

class RichTwoPartsText extends StatelessWidget {
  final String leftPart;
  final String rightPart;
  const RichTwoPartsText({
    super.key,
    required this.leftPart,
    required this.rightPart,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white70,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: leftPart,
            style: const TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const TextSpan(
            text: " 🌞",
          ),
          TextSpan(
            text: "\n $rightPart",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
