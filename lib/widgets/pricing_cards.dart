import 'package:flutter/material.dart';

const neon = Color(0xff00eaff);

class PricingCards extends StatelessWidget {
  const PricingCards({super.key});

  Widget row(String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: neon),
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withOpacity(.15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(price,
              style: const TextStyle(color: neon, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        row('4 Day Boost', '\$7.99'),
        row('35 Day Realtor/Broker/Vehicle Listing', '\$5.00'),
        row('15 Day Boost', '\$14.99'),
        row('Foreclosure Leads Monthly', '\$49.99'),
        row('One Foreclosure Lead', '\$9.99'),
        row('Post Your Own Sponsored Ad', '\$4.99'),
      ],
    );
  }
}
