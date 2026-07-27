import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../features/profile/public_user_profile_page.dart';

class PrimeXPeopleSearch extends StatefulWidget {
  const PrimeXPeopleSearch({super.key});

  @override
  State<PrimeXPeopleSearch> createState() => _PrimeXPeopleSearchState();
}

class _PrimeXPeopleSearchState extends State<PrimeXPeopleSearch> {
  final search = TextEditingController();
  String q = '';

  ImageProvider? avatarImage(String b64, String url) {
    if (b64.trim().isNotEmpty) {
      try {
        return MemoryImage(base64Decode(b64.trim()));
      } catch (_) {}
    }
    if (url.trim().isNotEmpty) return NetworkImage(url.trim());
    return null;
  }

  void openProfile(DocumentSnapshot d) {
    final x = d.data() as Map<String, dynamic>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PublicUserProfilePage(userId: d.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xEE07101D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF00E5FF), width: 2),
        boxShadow: const [BoxShadow(color: Color(0x6600E5FF), blurRadius: 14)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SEARCH PEOPLE',
              style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: search,
            style: const TextStyle(color: Colors.white),
            onChanged: (v) => setState(() => q = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search name or email',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00E5FF)),
              filled: true,
              fillColor: Colors.black,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (q.isNotEmpty)
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('profiles')
                  .limit(100)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  );
                }

                final docs = snap.data!.docs
                    .where((d) {
                      final x = d.data() as Map<String, dynamic>;
                      final name =
                          (x['displayName'] ?? '').toString().toLowerCase();
                      return name.contains(q);
                    })
                    .take(2)
                    .toList();

                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('No people found.',
                        style: TextStyle(color: Colors.white54)),
                  );
                }

                return Column(
                  children: docs.map((d) {
                    final x = d.data() as Map<String, dynamic>;
                    final img = avatarImage(
                      x['avatarBase64']?.toString() ?? '',
                      x['photoUrl']?.toString() ?? '',
                    );

                    return ListTile(
                      onTap: () => openProfile(d),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF101522),
                        backgroundImage: img,
                        child: img == null
                            ? const Icon(Icons.person, color: Color(0xFF00E5FF))
                            : null,
                      ),
                      title: Text(
                        x['displayName']?.toString() ?? 'Syntax Phantom',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text(
                        'Tap to view seller profile and listings',
                        style: TextStyle(color: Colors.white54),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Color(0xFF00E5FF), size: 16),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
