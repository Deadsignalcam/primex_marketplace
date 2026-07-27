import 'package:flutter/material.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                "PRIME X",
                style: TextStyle(
                  fontSize: 78,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "EVERYTHING YOU NEED",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF00E5FF),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "The future marketplace for real estate, vehicles, jobs, services & commercial deals.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/images/primex_banner.jpeg",
                height: 420,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
