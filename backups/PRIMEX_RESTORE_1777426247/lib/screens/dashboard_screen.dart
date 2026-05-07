import 'package:flutter/material.dart';
import '../data/property_store.dart';
import '../data/lead_store.dart';
import 'website_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<String> menu = [
    "Dashboard",
    "Properties",
    "Add Property",
    "Leads",
    "Messages",
    "Users",
    "Reports",
    "Settings",
  ];

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WebsiteScreen()),
      (route) => false,
    );
  }

  Widget page() {
    switch (selectedIndex) {
      case 1:
        return ListView.builder(
          itemCount: PropertyStore.properties.length,
          itemBuilder: (c, i) {
            final p = PropertyStore.properties[i];
            return ListTile(
              title: Text(p.title),
              subtitle: Text(p.location),
              trailing: Text(p.price),
            );
          },
        );

      case 3:
        return ListView.builder(
          itemCount: LeadStore.leads.length,
          itemBuilder: (c, i) {
            final l = LeadStore.leads[i];
            return ListTile(
              title: Text(l.name),
              subtitle: Text("${l.property} | ${l.phone}"),
            );
          },
        );

      default:
        return Center(child: Text(menu[selectedIndex]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: const Color(0xFF0F2A3D),
            child: Column(
              children: [
                const SizedBox(height: 40),
                ...List.generate(menu.length, (i) {
                  return ListTile(
                    title: Text(menu[i], style: const TextStyle(color: Colors.white)),
                    onTap: () => setState(() => selectedIndex = i),
                  );
                }),
                const Spacer(),
                ListTile(
                  title: const Text("Logout", style: TextStyle(color: Colors.white)),
                  tileColor: Colors.red,
                  onTap: logout,
                )
              ],
            ),
          ),
          Expanded(child: page()),
        ],
      ),
    );
  }
}
