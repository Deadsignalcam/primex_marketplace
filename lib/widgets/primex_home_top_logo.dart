import 'package:flutter/material.dart';

class PrimeXHomeTopLogo extends StatelessWidget {
  const PrimeXHomeTopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.38),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.4),
      ),
      child: const Column(
        children: [
          Text(
            'PRIMEX MARKETPLACE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'SELL • BUY • CONNECT • GROW',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
