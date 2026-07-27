import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveFeedScreen extends StatelessWidget {
  const LiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = FirebaseFirestore.instance
        .collection('listings')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PrimeX Marketplace'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: listings.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No listings yet'),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['title'] ?? ''),
                  subtitle: Text(data['category'] ?? ''),
                  trailing: Text('\$${data['price'] ?? ''}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
