import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF38F5FF), width: 2),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF091330),
            Color(0xFF0B1F52),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x8838F5FF),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "OWNER ADMIN PANEL",
            style: TextStyle(
              color: Color(0xFFD96CFF),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              shadows: [
                Shadow(
                  color: Color(0xFFD96CFF),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _topBox("124", "ACTIVE USERS"),
              const SizedBox(width: 18),
              _topBox("\$2,430", "MONTHLY SALES"),
              const SizedBox(width: 18),
              _topBox("87", "LIVE POSTS"),
            ],
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF38F5FF),
                        width: 2,
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF091330),
                          Color(0xFF102A6B),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "ANALYTICS / TRACKING AREA",
                        style: TextStyle(
                          color: Color(0xFF72FFE8),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xFF72FFE8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF38F5FF),
                        width: 2,
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF08111F),
                          Color(0xFF112C63),
                        ],
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ADMIN TOOLS",
                          style: TextStyle(
                            color: Color(0xFF72FFE8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          "• Remove Listings\n"
                          "• Ban Accounts\n"
                          "• Track Leads\n"
                          "• Stripe Revenue\n"
                          "• Approve Realtors\n"
                          "• Review Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBox(String value, String title) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFF38F5FF),
            width: 2,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0A1737),
              Color(0xFF133A7A),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF72FFE8),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Color(0xFF72FFE8),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
