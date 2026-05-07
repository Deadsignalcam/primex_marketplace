import 'package:flutter/material.dart';
import '../data/property_store.dart';
import 'request_info_screen.dart';

class WebsiteScreen extends StatelessWidget {
  const WebsiteScreen({super.key});

  static const navy = Color(0xFF0B1D2A);
  static const gold = Color(0xFFD4AF37);
  static const bg = Color(0xFFF5F2EA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _nav(),
            _hero(),
            _search(),
            _properties(context),
          ],
        ),
      ),
    );
  }

  // ================= NAV =================
  Widget _nav() {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Text(
            "PROMISED LAND",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: navy),
          ),
          const SizedBox(width: 8),
          const Text("LLC", style: TextStyle(fontSize: 12)),
          const Spacer(),
          _navItem("HOME"),
          _navItem("PROPERTIES"),
          _navItem("ABOUT US"),
          _navItem("INVESTORS"),
          _navItem("CONTACT"),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: const Text("INQUIRE NOW"),
          )
        ],
      ),
    );
  }

  Widget _navItem(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // ================= HERO =================
  Widget _hero() {
    return Container(
      height: 420,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/promised_land_login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(.35),
        padding: const EdgeInsets.only(left: 60),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BUILDING LEGACY.",
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text("CREATING GENERATIONS.",
                style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 20),
            SizedBox(
              width: 450,
              child: Text(
                "Promised Land Property Holdings LLC is committed to acquiring and developing properties that build wealth and create a lasting impact for generations to come.",
                style: TextStyle(color: Colors.white, height: 1.5),
              ),
            ),
            SizedBox(height: 20),
            Text("VIEW AVAILABLE PROPERTIES →",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH =================
  Widget _search() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Center(
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
          ),
          child: Column(
            children: [
              const Text("FIND YOUR NEXT INVESTMENT",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _field("City, County, or State")),
                  const SizedBox(width: 10),
                  Expanded(child: _field("All Types")),
                  const SizedBox(width: 10),
                  Expanded(child: _field("Min Price - Max Price")),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: gold),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("SEARCH"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // ================= PROPERTIES =================
  Widget _properties(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FEATURED PROPERTIES",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: PropertyStore.properties.map((p) {
              return SizedBox(
                width: 250,
                child: Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/promised_land_login_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.price,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(p.title),
                            Text(p.location,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            Text(p.status,
                                style: const TextStyle(
                                    color: gold, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => RequestInfoScreen(
                                            propertyTitle: p.title)),
                                  );
                                },
                                child: const Text("VIEW DETAILS"),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
