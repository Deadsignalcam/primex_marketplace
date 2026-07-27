import 'package:flutter/material.dart';
import '../listings/listings_page.dart';

class PrimeXPostHubPage extends StatelessWidget {
  const PrimeXPostHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = [
      'General - Free to Post',
      'Jewelry',
      'Phones',
      'Gaming',
      'Property',
      'Laptop',
      'Tools',
      'Vehicles',
      'Services',
      'Jobs',
      'Electronics',
      'Fashion',
      'Pets',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF020B12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111820),
        title: const Text('Post to PrimeX'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/primex_home_bg.png'),
            fit: BoxFit.cover,
            opacity: .22,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CREATE LISTING',
                style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose a category below. It will open the posting form already wired to that category.',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  itemCount: cats.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.6,
                  ),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ListingsPage(initialCategory: cats[i]),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.45),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF00E5FF), width: 1.2),
                        ),
                        child: Center(
                          child: Text(
                            cats[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
