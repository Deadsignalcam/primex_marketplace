import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrimeXAffiliateCashoutPage extends StatefulWidget {
  const PrimeXAffiliateCashoutPage({super.key});

  @override
  State<PrimeXAffiliateCashoutPage> createState() =>
      _PrimeXAffiliateCashoutPageState();
}

class _PrimeXAffiliateCashoutPageState
    extends State<PrimeXAffiliateCashoutPage> {
  String method = 'PayPal';
  final payoutHandle = TextEditingController();
  final notes = TextEditingController();
  bool saving = false;

  Future<void> submit() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    if (payoutHandle.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Enter your payout email, tag, or account ID.')),
      );
      return;
    }

    setState(() => saving = true);

    final affDoc = await FirebaseFirestore.instance
        .collection('affiliates')
        .doc(u.uid)
        .get();

    final d = affDoc.data() ?? {};
    final pending = d['pendingPayout'] ?? 0;

    await FirebaseFirestore.instance
        .collection('affiliate_payout_requests')
        .add({
      'uid': u.uid,
      'email': u.email ?? '',
      'displayName': d['displayName'] ?? '',
      'affiliateCode': d['affiliateCode'] ?? d['referralCode'] ?? '',
      'method': method,
      'payoutHandle': payoutHandle.text.trim(),
      'notes': notes.text.trim(),
      'amountRequested': pending,
      'status': 'pending_admin_review',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('affiliates').doc(u.uid).set({
      'lastPayoutRequestAt': FieldValue.serverTimestamp(),
      'lastPayoutMethod': method,
      'lastPayoutStatus': 'pending_admin_review',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cash out request sent for admin review.')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final methods = ['PayPal', 'Cash App', 'Stripe', 'Bank/Zelle', 'Other'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cash Out Request'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/primex_jobs_bg.png',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.72))),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Icon(Icons.payments, color: Colors.greenAccent, size: 82),
              const SizedBox(height: 12),
              const Text(
                'Request Affiliate Cash Out',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose PayPal, Cash App, Stripe or another payout method. PrimeX Admin reviews and approves payouts.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: method,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                decoration: input('Payout Method'),
                items: methods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => method = v ?? 'PayPal'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: payoutHandle,
                style: const TextStyle(color: Colors.white),
                decoration:
                    input('PayPal email / Cash App \$tag / Stripe email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notes,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: input('Notes for Admin'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: saving ? null : submit,
                icon: const Icon(Icons.send),
                label: Text(saving ? 'Sending...' : 'Submit Cash Out Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration input(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(.65),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      );
}
