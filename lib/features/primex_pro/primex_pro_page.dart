import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../map/map_page.dart';

class PrimeXProPage extends StatelessWidget {
  const PrimeXProPage({super.key});

  Future<void> seedDemoLeads(BuildContext context) async {
    final leads = [
      {
        'title': 'Foreclosure Lead - Johnstown Property',
        'leadType': 'Foreclosure',
        'category': 'Property',
        'address': '541 Pine St',
        'city': 'Johnstown',
        'state': 'PA',
        'price': '125000',
        'status': 'Active',
        'lat': 40.3267,
        'lng': -78.9219,
        'source': 'PrimeX Pro',
        'details':
            'Foreclosure-style property lead with map pin, address, price, and lead details.',
        'proOnly': true,
        'showOnMap': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Sheriff Sale Lead',
        'leadType': 'Sheriff Sale',
        'category': 'Property',
        'address': 'Cambria County Lead',
        'city': 'Johnstown',
        'state': 'PA',
        'price': '49900',
        'status': 'Pending Review',
        'lat': 40.3320,
        'lng': -78.9300,
        'source': 'PrimeX Pro',
        'details':
            'Sheriff sale lead for investor review. Confirm county status before purchase.',
        'proOnly': true,
        'showOnMap': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Inspection Job Lead',
        'leadType': 'Job Lead',
        'category': 'Jobs',
        'address': 'Local inspection request',
        'city': 'Johnstown',
        'state': 'PA',
        'price': '85',
        'status': 'Open',
        'lat': 40.3200,
        'lng': -78.9100,
        'source': 'PrimeX Jobs',
        'details':
            'Property inspection lead. Vendor can accept, message, and save lead.',
        'proOnly': false,
        'showOnMap': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final lead in leads) {
      await FirebaseFirestore.instance.collection('pro_leads').add(lead);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PrimeX Pro lead pins added')),
      );
    }
  }

  Widget proButton(BuildContext context, IconData icon, String title,
      String sub, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF07101D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF00E5FF)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF00E5FF), size: 34),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF00E5FF)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PrimeX Pro'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Text(
            'PrimeX Pro Lead Dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Unlock foreclosure, sheriff sale, tax sale, job, and service leads with map pin details.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          proButton(
            context,
            Icons.map,
            'Open Lead Map',
            'Pins show foreclosure, job, service, tax, and sheriff leads.',
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MapPage())),
          ),
          proButton(
            context,
            Icons.gavel,
            'Foreclosure / Sheriff / Tax Leads',
            'PrimeX Pro property leads with map location and details.',
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MapPage())),
          ),
          proButton(
            context,
            Icons.work,
            'Job Leads',
            'Inspection, preservation, contractor, and vendor leads.',
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MapPage())),
          ),
          proButton(
            context,
            Icons.handyman,
            'Service Leads',
            'Service requests and local job opportunities.',
            () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const MapPage())),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => seedDemoLeads(context),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Add Demo Lead Pins'),
          ),
        ],
      ),
    );
  }
}
