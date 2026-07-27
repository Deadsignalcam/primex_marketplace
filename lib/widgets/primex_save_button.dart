import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXSaveButton extends StatelessWidget {
  final String itemId;
  final String type;
  final String title;
  final String mediaUrl;

  const PrimeXSaveButton({
    super.key,
    required this.itemId,
    required this.type,
    required this.title,
    this.mediaUrl = '',
  });

  Future<void> save(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login first to save.')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_items')
        .doc(itemId)
        .set({
      'itemId': itemId,
      'type': type,
      'title': title,
      'mediaUrl': mediaUrl,
      'savedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to your profile.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => save(context),
      icon: const Icon(Icons.bookmark_add, size: 16),
      label: const Text('Save'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00E5FF),
        side: const BorderSide(color: Color(0xFF00E5FF)),
      ),
    );
  }
}
