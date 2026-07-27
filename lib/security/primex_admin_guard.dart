import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXAdminGuard extends StatefulWidget {
  final Widget child;
  const PrimeXAdminGuard({super.key, required this.child});

  @override
  State<PrimeXAdminGuard> createState() => _PrimeXAdminGuardState();
}

class _PrimeXAdminGuardState extends State<PrimeXAdminGuard> {
  final codeController = TextEditingController();
  bool unlocked = false;
  bool checking = false;
  bool needsSetup = false;

  bool get isOwner {
    final email =
        FirebaseAuth.instance.currentUser?.email?.toLowerCase().trim();
    return email == 'rosariogonzalezrosalind@gmail.com';
  }

  Future<void> checkOrCreateCode() async {
    if (!isOwner) return;
    setState(() => checking = true);

    final ref =
        FirebaseFirestore.instance.collection('admin_settings').doc('security');
    final doc = await ref.get();
    final typed = codeController.text.trim();

    if (typed.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use at least 6 characters.')),
      );
      setState(() => checking = false);
      return;
    }

    final realCode = (doc.data()?['adminCode'] ?? '').toString().trim();

    if (!doc.exists || realCode.isEmpty) {
      await ref.set({
        'adminCode': typed,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': FirebaseAuth.instance.currentUser?.uid,
      }, SetOptions(merge: true));

      setState(() => unlocked = true);
    } else if (typed == realCode) {
      setState(() => unlocked = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong admin code.')),
      );
    }

    setState(() => checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!isOwner) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('Access denied.',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
      );
    }

    if (unlocked) return widget.child;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text('Private Admin Lock'),
          backgroundColor: Colors.black),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF07111F),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, color: Colors.cyanAccent, size: 50),
              const SizedBox(height: 12),
              const Text(
                'Enter or Create Admin Code',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 10),
              const Text(
                'First time: type your private code and press Unlock. After that, use the same code.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Private admin code',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF111827),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: checking ? null : checkOrCreateCode,
                icon: const Icon(Icons.verified_user),
                label: Text(checking ? 'Checking...' : 'Unlock Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
