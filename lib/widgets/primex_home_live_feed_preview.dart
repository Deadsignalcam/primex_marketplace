import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXHomeLiveFeedPreview extends StatelessWidget {
  const PrimeXHomeLiveFeedPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('live_feed')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        return Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1020),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.cyanAccent.withOpacity(.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('HOMEPAGE LIVE FEED',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (snap.hasError)
                Text('Homepage Live Feed Error: ${snap.error}',
                    style: const TextStyle(color: Colors.redAccent)),
              if (!snap.hasData && !snap.hasError)
                const Center(child: CircularProgressIndicator()),
              if (snap.hasData && docs.isEmpty)
                const Text('No homepage live posts yet.',
                    style: TextStyle(color: Colors.white70)),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: const Text('PrimeX User',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    data['description'] ?? '',
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 2,
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
