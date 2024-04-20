import 'package:flutter/material.dart';

class CircularProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  const CircularProfileAvatar(
      {super.key, required this.imageUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 10.0,
            offset: const Offset(3, 9),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl.isEmpty
            ? const NetworkImage('https://i.imgur.com/jNNT4LE.png')
            : NetworkImage(imageUrl),
      )
    );
  }
}
