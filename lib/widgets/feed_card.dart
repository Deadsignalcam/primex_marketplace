import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const FeedCard({super.key, required this.id, required this.data});

  Future<void> deleteListing() async {
    await FirebaseFirestore.instance.collection('listings').doc(id).delete();
  }

  Future<void> editListing(BuildContext context) async {
    final title = TextEditingController(text: data['title'] ?? '');
    final price = TextEditingController(text: '${data['price'] ?? ''}');
    final desc = TextEditingController(text: data['description'] ?? '');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xff071127),
        title: const Text('Edit Listing',
            style: TextStyle(color: Colors.cyanAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: title,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Title')),
            TextField(
                controller: price,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Price')),
            TextField(
                controller: desc,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('listings')
                  .doc(id)
                  .update({
                'title': title.text,
                'price': price.text,
                'description': desc.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Save Edit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff07175c),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['title'] ?? '',
              style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(data['category'] ?? '',
              style: const TextStyle(color: Colors.white70)),
          Text('\$${data['price'] ?? ''}',
              style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(data['description'] ?? '',
              style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () => editListing(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit')),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                  onPressed: deleteListing,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }
}
