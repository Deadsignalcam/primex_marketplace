import 'package:flutter/material.dart';

class LiveAdsPromotionsPage extends StatelessWidget {
  const LiveAdsPromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ads = [
      ['Standard Ad Space', '4.99 / week', Icons.campaign],
      ['Business Spotlight', '9.99', Icons.workspace_premium],
      ['Homepage Banner', '19.99', Icons.web],
      ['Boost 4 Days', '7.99', Icons.trending_up],
      ['Boost 15 Days', '14.99', Icons.rocket_launch],
      ['Realtor / Broker / Vehicle 35 Days', '5.00', Icons.real_estate_agent],
      ['Sheriff / Tax / Foreclosure Monthly', '49.00', Icons.map],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('LIVE ADS & PROMOTIONS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Promote your listing, business, service, property, job, or banner on PrimeX Marketplace.',
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
          const SizedBox(height: 16),
          ...ads.map((ad) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1020),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent.withOpacity(.35)),
              ),
              child: Row(
                children: [
                  Icon(ad[2] as IconData, color: Colors.cyanAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ad[0] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '\$${ad[1]}',
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Build Your Ad / Upload Banner, Photo or Video'),
          ),
        ],
      ),
    );
  }
}
