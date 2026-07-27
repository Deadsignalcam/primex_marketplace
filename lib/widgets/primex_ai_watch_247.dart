import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXAIWatch247 extends StatelessWidget {
  const PrimeXAIWatch247({super.key});

  @override
  Widget build(BuildContext context) {
    final bannedWords = [
      'nudity',
      'sexual',
      'hate',
      'scam',
      'abuse',
      'phone number',
      'outside payment',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF), width: 1.3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🤖 AI WATCH 24/7 PLATFORM SAFETY',
            style: TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI reviews live feed posts, listings, ads, chat reports, abuse, nudity, scams, hate, and unsafe activity.',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: bannedWords.map((w) {
              return Chip(
                backgroundColor: Colors.redAccent.withOpacity(.25),
                label: Text(w,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('ai_flags')
                .limit(20)
                .snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Text(
                  'No active AI flags. Platform watch is standing by.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              }

              return Column(
                children: docs.map((d) {
                  final data = d.data();
                  final reason =
                      data['reason']?.toString() ?? 'Unsafe content flagged';
                  final type = data['type']?.toString() ?? 'Platform';
                  final status = data['status']?.toString() ?? 'open';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.16),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.redAccent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '$type • $reason\nStatus: $status',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('ai_flags')
                                .doc(d.id)
                                .update({
                              'status': 'removed',
                              'removedAt': FieldValue.serverTimestamp(),
                            });
                          },
                          child: const Text('REMOVE',
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
