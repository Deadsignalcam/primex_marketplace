import 'package:flutter/material.dart';

class AssistantCornerOrb extends StatelessWidget {
  const AssistantCornerOrb({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 16,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.cyanAccent.withOpacity(0.9),
              Colors.blueAccent.withOpacity(0.5),
              Colors.transparent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 25,
              spreadRadius: 2,
            )
          ],
        ),
        child: const Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
