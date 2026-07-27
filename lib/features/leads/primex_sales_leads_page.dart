import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimeXSalesLeadsPage extends StatelessWidget {
  const PrimeXSalesLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PrimeX Pro Market Leads'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('pro_leads')
                .where('showOnMap', isEqualTo: true)
                .snapshots(),
            builder: (context, snap) {
              final docs = snap.data?.docs ?? [];

              if (docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No Pro market leads yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(14),
                children: docs.map((doc) {
                  final lead = doc.data() as Map<String, dynamic>;
                  final title = (lead['title'] ?? 'PrimeX Pro Lead').toString();
                  final county = (lead['county'] ?? '').toString();
                  final state = (lead['state'] ?? '').toString();

                  return Card(
                    color: const Color(0xFF111827),
                    child: ListTile(
                      leading: const Icon(Icons.lock_open,
                          color: Colors.greenAccent),
                      title: Text(title,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '$county $state',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
