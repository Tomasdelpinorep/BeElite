import 'package:flutter/material.dart';

class CircularProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  const CircularProfileAvatar({super.key, required this.imageUrl, this.radius = 40});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}