import 'package:flutter/material.dart';

class PrimeXLogo extends StatelessWidget {
  const PrimeXLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFF00F5FF),
          width: 2,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF061224),
            Color(0xFF081B38),
            Color(0xFF061224),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x6600F5FF),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Text(
                      'PRIME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'X',
                      style: TextStyle(
                        color: Color(0xFF00F5FF),
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Text(
                  'MARKETPLACE',
                  style: TextStyle(
                    color: Color(0xFF00F5FF),
                    letterSpacing: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'SELL • BUY • CONNECT • GROW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF00F5FF),
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'AI',
                style: TextStyle(
                  color: Color(0xFF00F5FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
