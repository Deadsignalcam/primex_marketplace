import 'package:flutter/material.dart';

class PrimeXGrowthChart extends StatelessWidget {
  const PrimeXGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final bars = [
      ['Users', 4, .30],
      ['Listings', 29, .90],
      ['Feed', 1, .18],
      ['Ads', 3, .25],
      ['Flags', 0, .05],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.32),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📈 Growth Analytics Chart',
              style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...bars.map((b) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 85,
                    child: Text('${b[0]}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: b[2] as double,
                      minHeight: 14,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF00E5FF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${b[1]}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
