import 'package:flutter/material.dart';

class PostHistoryPage extends StatelessWidget {
  const PostHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = const [
      ['Saved Job', 'Roofing Crew Needed', 'ABC Roofing', '\$28/hr'],
      ['Saved Service', 'Office Cleaning', 'CleanPro', '\$150/visit'],
      ['Saved Gig', 'Moving Helpers', 'Fast Move LLC', '\$22/hr'],
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Saved Post History'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/primex_jobs_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(.68)),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Saved Post History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              for (final p in posts) card(p),
            ],
          ),
        ],
      ),
    );
  }

  Widget card(List<String> p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: ListTile(
        leading: const Icon(Icons.bookmark, color: Colors.cyanAccent),
        title: Text(p[1],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900)),
        subtitle: Text('${p[0]} • ${p[2]}',
            style: const TextStyle(color: Colors.white70)),
        trailing: Text(p[3],
            style: const TextStyle(
                color: Colors.greenAccent, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
