import 'package:flutter/material.dart';

class DigitalBackground extends StatelessWidget {
  final Widget child;

  const DigitalBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/syntax_neon_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.70),
                  const Color(0xFF031B44).withOpacity(.55),
                  Colors.black.withOpacity(.80),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.18),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
