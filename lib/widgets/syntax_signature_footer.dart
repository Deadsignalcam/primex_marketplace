import 'package:flutter/material.dart';

class SyntaxSignatureFooter extends StatelessWidget {
  const SyntaxSignatureFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.cyanAccent.withOpacity(.75), width: 1),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'MY SIGNATURE POWER BY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 5,
              shadows: [
                Shadow(color: Colors.cyanAccent, blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Syntax Phantom',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 31,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.5,
              shadows: [
                Shadow(color: Colors.cyanAccent.withOpacity(.9), blurRadius: 8),
                const Shadow(color: Colors.blueAccent, blurRadius: 24),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '@2026',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 7,
              shadows: [
                Shadow(color: Colors.cyanAccent, blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.cyanAccent.withOpacity(.65)),
          const SizedBox(height: 10),
          const Text(
            'POLICY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 7,
              shadows: [
                Shadow(color: Colors.cyanAccent, blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Terms of Service  |  Privacy Policy  |  Community Guidelines  |  Refund Policy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: Colors.cyanAccent.withOpacity(.65)),
          const SizedBox(height: 10),
          const Text(
            'PHILIPPIANS IV:13',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              shadows: [
                Shadow(color: Colors.cyanAccent, blurRadius: 10),
              ],
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            '“I CAN DO ALL THINGS THROUGH CHRIST\nWHO STRENGTHENS ME.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
