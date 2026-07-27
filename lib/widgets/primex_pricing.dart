import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/stripe_links.dart';

class PrimeXPricing extends StatelessWidget {
  const PrimeXPricing({super.key});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget buildCard({
    required String title,
    required String price,
    required String button,
    required String url,
  }) {
    return Container(
      width: 230,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blueAccent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),
          Text(price,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => openLink(url),
            child: Text(button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildCard(
            title: '35 Day Realtor Access',
            price: '\$5.00',
            button: 'Purchase',
            url: StripeLinks.realtor35Days,
          ),
          buildCard(
            title: '35 Day Vehicle Access',
            price: '\$5.00',
            button: 'Purchase',
            url: StripeLinks.vehicle35Days,
          ),
          buildCard(
            title: 'Boost 4 Days',
            price: '\$7.99',
            button: 'Boost Now',
            url: StripeLinks.boost4Days,
          ),
          buildCard(
            title: 'Boost 15 Days',
            price: '\$14.99',
            button: 'Boost Now',
            url: StripeLinks.boost15Days,
          ),
          buildCard(
            title: 'Foreclosure Lead',
            price: '\$9.99',
            button: 'Unlock Lead',
            url: StripeLinks.foreclosureLead,
          ),
          buildCard(
            title: 'PrimeX Pro',
            price: '\$49.99/mo',
            button: 'Subscribe',
            url: StripeLinks.primeXPro,
          ),
        ],
      ),
    );
  }
}
