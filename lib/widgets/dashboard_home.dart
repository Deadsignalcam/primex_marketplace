import 'package:flutter/material.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
            ],
          ),
          border: Border.all(
            color: Colors.blueAccent,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.blueAccent,
              blurRadius: 12,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 14),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget activityTile(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueAccent.withOpacity(.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.yellow),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PrimeX Investor Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              statCard(
                "Active Leads",
                "248",
                Icons.real_estate_agent,
              ),
              statCard(
                "Monthly Revenue",
                "\$18.4K",
                Icons.attach_money,
              ),
              statCard(
                "Properties Sold",
                "42",
                Icons.home_work,
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0A0F2C),
                  Color(0xFF101B45),
                ],
              ),
              border: Border.all(
                color: Colors.blueAccent,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Market Snapshot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "\$145K",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Johnstown",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "\$220K",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Pittsburgh",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "\$89K",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Cambria",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "\$310K",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Philadelphia",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            "Recent Activity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          activityTile(
            "New foreclosure lead uploaded in Johnstown PA",
          ),
          activityTile(
            "Investor subscribed to Premium Plan",
          ),
          activityTile(
            "Property sold for \$220,000",
          ),
          activityTile(
            "New message received from buyer",
          ),
          activityTile(
            "Offer submitted on duplex property",
          ),
        ],
      ),
    );
  }
}
