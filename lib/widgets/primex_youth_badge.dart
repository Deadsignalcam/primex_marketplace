import 'package:flutter/material.dart';

class PrimeXYouthBadge extends StatelessWidget {
  const PrimeXYouthBadge({
    super.key,
    this.level = 'Affiliate Starter',
    this.founder = false,
  });

  final String level;
  final bool founder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Text(
        founder
            ? '🏆 Founding Affiliate • $level'
            : '🎓 Youth Entrepreneur • $level',
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
