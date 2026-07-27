import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_profile_circle.dart';
import 'primex_chat_page.dart';

class PrimeXMessagesPage extends StatelessWidget {
  const PrimeXMessagesPage({super.key});

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    if (myUid.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text('Log in to view messages.',
                style: TextStyle(color: Colors.white70))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar:
          AppBar(backgroundColor: Colors.black, title: const Text('Messages')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: myUid)
            .snapshots(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('No messages yet.',
                  style: TextStyle(color: Colors.white70)),
            );
          }

          docs.sort((a, b) {
            final ad = a.data() as Map<String, dynamic>;
            final bd = b.data() as Map<String, dynamic>;
            final at = ad['updatedAt'];
            final bt = bd['updatedAt'];
            if (at is Timestamp && bt is Timestamp) return bt.compareTo(at);
            return 0;
          });

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white12),
            itemBuilder: (context, i) {
              final d = docs[i].data() as Map<String, dynamic>;
              final participants = List<String>.from(d['participants'] ?? []);
              final otherId =
                  participants.firstWhere((x) => x != myUid, orElse: () => '');

              if (otherId.isEmpty) return const SizedBox.shrink();

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherId)
                    .get(),
                builder: (context, userSnap) {
                  final u =
                      (userSnap.data?.data() as Map<String, dynamic>?) ?? {};
                  final name = (u['displayName'] ??
                          u['name'] ??
                          d['otherName'] ??
                          'PrimeX Member')
                      .toString();
                  final photo = (u['photoUrl'] ??
                          u['profilePhoto'] ??
                          u['avatarUrl'] ??
                          '')
                      .toString();

                  return ListTile(
                    leading: PrimeXProfileCircle(uid: otherId, radius: 24),
                    title: Text(name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      (d['lastMessage'] ??
                              d['itemTitle'] ??
                              'Open conversation')
                          .toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: const Icon(Icons.chevron_right,
                        color: Color(0xFF00E5FF)),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrimeXChatPage(
                          otherUserId: otherId,
                          otherName: name,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
