import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_safe_contact_buttons.dart';

import '../safety/safe_meet_page.dart';

class ListingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final String listingId;

  const ListingDetailsPage({
    super.key,
    required this.data,
    required this.listingId,
  });

  List<String> media(dynamic v) {
    if (v is List)
      return v
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    if (v is String && v.trim().isNotEmpty) return [v.trim()];
    return [];
  }

  bool isOwner() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final owner = (data['ownerUid'] ??
            data['userId'] ??
            data['sellerUid'] ??
            data['uid'] ??
            '')
        .toString();
    return uid.isNotEmpty && uid == owner;
  }

  Future<void> editListing(BuildContext context) async {
    final title = TextEditingController(text: (data['title'] ?? '').toString());
    final price = TextEditingController(text: (data['price'] ?? '').toString());
    final details = TextEditingController(
        text: (data['details'] ?? data['description'] ?? '').toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title:
            const Text('Edit Listing', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
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
                  controller: details,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Details')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('listings')
                  .doc(listingId)
                  .set({
                'title': title.text.trim(),
                'price': price.text.trim(),
                'details': details.text.trim(),
                'description': details.text.trim(),
                'updatedAt': FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteListing(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .delete();
    if (context.mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Listing deleted.')));
    }
  }

  Future<void> toggleAutoRenew(bool value) async {
    await FirebaseFirestore.instance.collection('listings').doc(listingId).set({
      'autoRenew': value,
      'renewEveryHours': 24,
      'lastRenewedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final title = (data['title'] ?? 'PrimeX Listing').toString();
    final price = (data['price'] ?? '').toString();
    final details = (data['details'] ?? data['description'] ?? '').toString();
    final city = (data['city'] ?? '').toString();
    final state = (data['state'] ?? '').toString();
    final photos = [
      ...media(data['photoUrls']),
      ...media(data['imageUrls']),
      ...media(data['photos']),
      ...media(data['images']),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Listing Details')),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/primex_trends_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
          Container(color: Colors.black.withOpacity(.58)),
          ListView(
            padding: const EdgeInsets.all(14),
            children: [
              if (photos.isNotEmpty)
                SizedBox(
                  height: 170,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: photos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => Container(
                      width: 170,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFF061125),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(.45)),
                      ),
                      child: Image.network(photos[i], fit: BoxFit.contain),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              if (price.isNotEmpty)
                Text('\$$price',
                    style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              if (city.isNotEmpty || state.isNotEmpty)
                Text('$city $state',
                    style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              PrimeXSafeContactButtons(
                receiverId:
                    (data['ownerUid'] ?? data['userId'] ?? data['uid'] ?? '')
                        .toString(),
                receiverName: (data['ownerName'] ??
                        data['displayName'] ??
                        data['sellerName'] ??
                        'PrimeX Member')
                    .toString(),
                receiverPhoto: (data['ownerPhoto'] ??
                        data['photoUrl'] ??
                        data['avatarUrl'] ??
                        '')
                    .toString(),
                sourceTitle: (data['title'] ?? 'PrimeX Listing').toString(),
                listingId: listingId,
              ),
              const SizedBox(height: 12),
              Text(details.isEmpty ? 'No details added.' : details,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SafeMeetPage(listingTitle: title)),
                  );
                },
                icon: const Icon(Icons.shield),
                label: const Text('Start Safe Meet'),
              ),
              if (isOwner()) ...[
                const SizedBox(height: 14),
                SwitchListTile(
                  value: data['autoRenew'] == true,
                  onChanged: toggleAutoRenew,
                  title: const Text('Auto-renew every 24 hours',
                      style: TextStyle(color: Colors.white)),
                  activeThumbColor: Colors.cyanAccent,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () => editListing(context),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'))),
                    const SizedBox(width: 10),
                    Expanded(
                        child: OutlinedButton.icon(
                            onPressed: () => deleteListing(context),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'))),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
