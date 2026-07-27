import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_profile_contact_bar.dart';

class PrimeXPublicProfilePage extends StatelessWidget {
  const PrimeXPublicProfilePage({
    super.key,
    required this.uid,
    required this.profile,
  });

  final String uid;
  final Map<String, dynamic> profile;

  Future<void> followUser() async {
    final me = FirebaseAuth.instance.currentUser;
    if (me == null || me.uid == uid) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(me.uid)
        .set({
      'uid': me.uid,
      'email': me.email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(me.uid)
        .collection('following')
        .doc(uid)
        .set({
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = (profile['displayName'] ??
            profile['sellerName'] ??
            profile['ownerName'] ??
            'Syntax Phantom')
        .toString();
    final photo =
        (profile['photoUrl'] ?? profile['profilePhoto'] ?? '').toString();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(name),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Listings'),
              Tab(text: 'Ads'),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/primex_jobs_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.74)),
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.cyanAccent,
                  backgroundImage:
                      photo.startsWith('http') ? NetworkImage(photo) : null,
                  child: photo.startsWith('http')
                      ? null
                      : const Icon(Icons.person, size: 52, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: followUser,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Follow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PrimeXProfileContactBar(profile: profile),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      list('professional_live_feed', 'uid'),
                      list('listings', 'uid'),
                      list('ads_promotions', 'uid'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget list(String collection, String field) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .where(field, isEqualTo: uid)
          .limit(30)
          .snapshots(),
      builder: (context, snap) {
        final docs = snap.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Text(
              'Nothing posted yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: docs.map((doc) {
            final d = doc.data();
            final title =
                (d['title'] ?? d['text'] ?? d['description'] ?? 'PrimeX Item')
                    .toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.70),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
