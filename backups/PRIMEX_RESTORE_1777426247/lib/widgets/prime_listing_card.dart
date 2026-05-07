import 'package:flutter/material.dart';

class PrimeListingCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;

  const PrimeListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(price, style: const TextStyle(color: Color(0xFFD7A847), fontWeight: FontWeight.bold)),
          Text(location, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
