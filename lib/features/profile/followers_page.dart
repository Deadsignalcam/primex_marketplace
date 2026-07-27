import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/primex_profile_circle.dart';
import 'public_user_profile_page.dart';

class FollowersPage extends StatelessWidget {
  final String uid;
  final String title;
  final String type;

  const FollowersPage({
    super.key,
    required this.uid,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final col = type == 'following' ? 'following' : 'followers';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection(col)
            .snapshots(),
        builder: (context, snap) {
          final docs = snap.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                type == 'following'
                    ? 'Not following anyone yet.'
                    : 'No followers yet.',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white12),
            itemBuilder: (context, i) {
              final x = docs[i].data() as Map<String, dynamic>;

              final personUid = type == 'following'
                  ? (x['followingId'] ?? x['userId'] ?? docs[i].id).toString()
                  : (x['followerId'] ?? x['userId'] ?? docs[i].id).toString();

              final fallback = type == 'following'
                  ? (x['followingName'] ?? x['name'] ?? 'PrimeX User')
                      .toString()
                  : (x['followerName'] ?? x['name'] ?? 'PrimeX User')
                      .toString();

              return ListTile(
                leading: PrimeXProfileCircle(uid: personUid, radius: 24),
                title: Text(fallback,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(type == 'following' ? 'Following' : 'Follower',
                    style: const TextStyle(color: Colors.white54)),
                trailing:
                    const Icon(Icons.chevron_right, color: Color(0xFF00E5FF)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PublicUserProfilePage(userId: personUid)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
