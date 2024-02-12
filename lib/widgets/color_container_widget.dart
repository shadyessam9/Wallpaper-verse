// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ColorContainerWidget extends StatelessWidget {
  final Color color; // Updated to hold a color instead of an image URL

  const ColorContainerWidget({
    Key? key,
    required this.color, // Updated to accept a color instead of an image URL
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        height: 100,
        width: 100, // Ensure the width and height are equal for a perfect circle
        child: Container(
          decoration: BoxDecoration(
            color: color, // Use the provided color here
            shape: BoxShape.circle, // Shape set to circle
          ),
        ),
      ),
    );
  }
}
