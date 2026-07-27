import 'package:flutter/material.dart';

class PrimeXYouthProgramPage extends StatelessWidget {
  const PrimeXYouthProgramPage({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = [
      ['Bronze Explorer', 'Start learning PrimeX safety and community basics.'],
      [
        'Silver Builder',
        'Create positive activity and complete learning steps.'
      ],
      ['Gold Creator', 'Earn trusted participation and marketplace skills.'],
      ['Diamond Leader', 'Show strong responsibility and community support.'],
      [
        'PrimeX Elite',
        'Top youth badge level with guardian-approved participation.'
      ],
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PrimeX Youth Program'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/primex_home_bg.png'),
            fit: BoxFit.cover,
            opacity: .32,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.72),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ages 13–17 Youth Badge Program',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is not the paid affiliate program. Youth members can earn badge levels with parent/guardian approval. No commissions, no payouts, no contracts.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...levels.map((x) => Card(
                  color: const Color(0xFF0B1020).withOpacity(.88),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.cyanAccent,
                      child: Icon(Icons.workspace_premium, color: Colors.black),
                    ),
                    title: Text(x[0],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(x[1],
                        style: const TextStyle(color: Colors.white70)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
