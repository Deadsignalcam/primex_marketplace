import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/listings/edit_listing_page.dart';

class PrimeXListingOwnerActions extends StatelessWidget {
  final String listingId;
  final Map<String, dynamic> data;

  const PrimeXListingOwnerActions(
      {super.key, required this.listingId, required this.data});

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final owner =
        (data['userId'] ?? data['ownerId'] ?? data['uid'] ?? '').toString();

    if (myUid.isEmpty || owner != myUid) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    EditListingPage(listingId: listingId)),
          );
        },
        icon: const Icon(Icons.edit),
        label: const Text('Edit Listing'),
      ),
    );
  }
}
