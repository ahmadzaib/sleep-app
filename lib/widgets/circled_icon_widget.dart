import 'package:flutter/material.dart';

class CircledIconWidget extends StatelessWidget {
  final Color color;
  final IconData icon;
  const CircledIconWidget({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: color.withValues(alpha: .1),

      child: Center(
        child: CircleAvatar(
          backgroundColor: color.withValues(alpha: .2),
          radius: 25,
          child: Icon(icon, color: color),
        ),
      ),
    );
  }
}
