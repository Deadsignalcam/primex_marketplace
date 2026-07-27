import 'package:flutter/material.dart';

class FloatingAIOrb extends StatefulWidget {
  const FloatingAIOrb({super.key});

  @override
  State<FloatingAIOrb> createState() => _FloatingAIOrbState();
}

class _FloatingAIOrbState extends State<FloatingAIOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(0, -10 * _c.value),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent,
                  Colors.blueAccent.withOpacity(0.3),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.6),
                  blurRadius: 25,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
