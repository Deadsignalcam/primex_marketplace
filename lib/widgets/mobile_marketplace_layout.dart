import 'package:flutter/material.dart';

class MobileMarketplaceLayout extends StatelessWidget {
  const MobileMarketplaceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06101f),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'PrimeX',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.map, color: Colors.cyanAccent),
                      SizedBox(width: 12),
                      Icon(Icons.add_box, color: Colors.cyanAccent),
                      SizedBox(width: 12),
                      Icon(Icons.person, color: Colors.cyanAccent),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search PrimeX listings',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.cyanAccent),
                      filled: true,
                      fillColor: const Color(0xff111827),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: filterButton('Location')),
                      const SizedBox(width: 8),
                      Expanded(child: filterButton('Category')),
                      const SizedBox(width: 8),
                      Expanded(child: filterButton('Newest')),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  listingCard(
                    price: '\$599,000',
                    title: 'Fully renovated one family house',
                    meta: '3br • Bronx • Real Estate',
                    color: Colors.blueAccent,
                  ),
                  listingCard(
                    price: '\$9.99',
                    title: 'Foreclosure Lead',
                    meta: 'Pinned property lead • PrimeX Pro',
                    color: Colors.redAccent,
                  ),
                  listingCard(
                    price: '\$5.00',
                    title: 'Realtor / Broker / Vehicle Listing',
                    meta: '35 days posting',
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Center(
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget listingCard({
    required String price,
    required String title,
    required String meta,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xff111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border.all(color: color),
            ),
            child: Icon(Icons.image, color: color, size: 60),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(price,
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(meta, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
