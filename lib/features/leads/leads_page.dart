import 'package:flutter/material.dart';

class LeadsPage extends StatefulWidget {
  const LeadsPage({super.key});

  @override
  State<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends State<LeadsPage> {
  final leads = const [
    ['Job Lead', 'ABC Roofing', 'Roofing crew needed', '\$28/hr', '4 workers'],
    [
      'Service Lead',
      'CleanPro',
      'Office cleaning service',
      '\$150/visit',
      '2 workers'
    ],
    [
      'Gig Work',
      'Fast Move LLC',
      'Moving helpers needed',
      '\$22/hr',
      '3 workers'
    ],
    [
      'Contractor',
      'BuildRight',
      'Concrete contractor needed',
      '\$4,500/project',
      '6 workers'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Market Leads'),
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
                'PrimeX Market Leads',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Jobs, services, gigs, contractors and vendor opportunities.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 18),
              for (final l in leads) leadCard(l),
            ],
          ),
        ],
      ),
    );
  }

  Widget leadCard(List<String> l) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.business_center, color: Colors.cyanAccent, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l[0],
                    style: const TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold)),
                Text(l[2],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                Text(l[1], style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(l[3],
                  style: const TextStyle(
                      color: Colors.greenAccent, fontWeight: FontWeight.w900)),
              Text(l[4], style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}
