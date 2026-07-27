import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/primex_unlock_service.dart';

class PrimeXMyUnlocksPanel extends StatelessWidget {
  const PrimeXMyUnlocksPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: PrimeXUnlockService.myUnlocks(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.70),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00E5FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My PrimeX Unlocks',
                style: TextStyle(
                    color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (docs.isEmpty)
                const Text(
                  'No active paid unlocks yet.',
                  style: TextStyle(color: Colors.white70),
                )
              else
                ...docs.map((x) {
                  final d = x.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${d['plan'] ?? 'Unlock'} • ${d['type'] ?? ''}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }
}
