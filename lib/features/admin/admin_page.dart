import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/home_page.dart';
import '../profile/public_user_profile_page.dart';
import '../../services/primex_safety_service.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Widget aiWatchPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF07111F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PrimeX AI Autopilot Watch',
            style: TextStyle(
                color: Colors.cyanAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'AI Safety: ON. Watching posts, listings, ads, reports, scams, nudity, abuse, spam, and unsafe content. Owner keeps final control.',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('Owner Approval')),
              Chip(label: Text('3 Strikes')),
              Chip(label: Text('Reports Queue')),
              Chip(label: Text('Manual Override')),
            ],
          ),
        ],
      ),
    );
  }

  Widget reportsQueue() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reports')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        return sectionShell(
          'Reports Queue (${docs.length})',
          docs.isEmpty
              ? const Text('No reports yet.',
                  style: TextStyle(color: Colors.white54))
              : Column(
                  children: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final collection = (data['collection'] ?? '').toString();
                    final itemId = (data['itemId'] ?? '').toString();

                    return Card(
                      color: const Color(0xFF111827),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reason: ${data['reason'] ?? ''}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text('Item: $collection / $itemId',
                                style: const TextStyle(color: Colors.white60)),
                            Text('Status: ${data['status'] ?? 'pending'}',
                                style:
                                    const TextStyle(color: Colors.cyanAccent)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    await PrimeXSafetyService.hideItem(
                                        collection, itemId);
                                    await d.reference.set(
                                        {'status': 'hidden_action_taken'},
                                        SetOptions(merge: true));
                                  },
                                  child: const Text('Hide Item'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await d.reference.set(
                                        {'status': 'dismissed'},
                                        SetOptions(merge: true));
                                  },
                                  child: const Text('Dismiss'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  Widget sectionShell(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget contentSection(String title, String collection) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .limit(25)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        return sectionShell(
          '$title (${docs.length})',
          docs.isEmpty
              ? const Text('No items yet.',
                  style: TextStyle(color: Colors.white54))
              : Column(
                  children: docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final itemTitle = (data['title'] ??
                            data['adTitle'] ??
                            data['name'] ??
                            data['text'] ??
                            'Untitled')
                        .toString();
                    final userId = (data['userId'] ?? '').toString();

                    return Card(
                      color: const Color(0xFF111827),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(itemTitle,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Status: ${data['status'] ?? 'pending'}',
                                style:
                                    const TextStyle(color: Colors.cyanAccent)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: () =>
                                      PrimeXSafetyService.approveItem(
                                          collection, d.id),
                                  child: const Text('Approve'),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      PrimeXSafetyService.rejectItem(
                                          collection, d.id),
                                  child: const Text('Reject'),
                                ),
                                ElevatedButton(
                                  onPressed: () => PrimeXSafetyService.hideItem(
                                      collection, d.id),
                                  child: const Text('Hide'),
                                ),
                                ElevatedButton(
                                  onPressed: userId.isEmpty
                                      ? null
                                      : () => PrimeXSafetyService.strikeUser(
                                          userId),
                                  child: const Text('+ Strike'),
                                ),
                                ElevatedButton(
                                  onPressed: userId.isEmpty
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PublicUserProfilePage(
                                                      userId: userId),
                                            ),
                                          );
                                        },
                                  child: const Text('View Profile'),
                                ),
                                ElevatedButton(
                                  onPressed: userId.isEmpty
                                      ? null
                                      : () async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .set({
                                            'suspended': true,
                                            'status': 'suspended_by_admin',
                                            'suspendedAt':
                                                FieldValue.serverTimestamp(),
                                          }, SetOptions(merge: true));
                                        },
                                  child: const Text('Suspend User'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Admin Logout',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              }
            },
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
            icon: const Icon(Icons.dashboard, color: Colors.cyanAccent),
            label: const Text('Dashboard',
                style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
          },
        ),
        title: const Text('PrimeX Owner Command Center'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          aiWatchPanel(),
          reportsQueue(),
          contentSection('Ads & Promotions', 'ads_promotions'),
          contentSection('Live Feed Posts', 'posts'),
          contentSection('Marketplace Listings', 'listings'),
          contentSection('Jobs / Lead Data', 'lead_data'),
        ],
      ),
    );
  }
}
