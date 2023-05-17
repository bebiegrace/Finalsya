import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  final String imagePath;
  const MyLogo({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
