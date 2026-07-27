import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'public_user_profile_page.dart';

class SearchPeoplePage extends StatefulWidget {
  const SearchPeoplePage({super.key});

  @override
  State<SearchPeoplePage> createState() => _SearchPeoplePageState();
}

class _SearchPeoplePageState extends State<SearchPeoplePage> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent, width: 1.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(18),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SEARCH PEOPLE',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Search people...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.cyanAccent),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.cyanAccent),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onChanged: (v) =>
                        setState(() => query = v.trim().toLowerCase()),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final users = snap.data!.docs.where((doc) {
                        final d = doc.data() as Map<String, dynamic>;
                        final name = '${d['displayName'] ?? d['name'] ?? ''}'
                            .toLowerCase();
                        final email = '${d['email'] ?? ''}'.toLowerCase();
                        return query.isEmpty ||
                            name.contains(query) ||
                            email.contains(query);
                      }).toList();

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          final data = users[i].data() as Map<String, dynamic>;
                          final name = data['displayName'] ??
                              data['name'] ??
                              'PrimeX User';
                          final email = '';

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111827),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.cyanAccent,
                                child: Icon(Icons.person,
                                    color: Colors.black, size: 34),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('PrimeX member',
                                  style: TextStyle(color: Colors.white70)),
                              trailing: const Icon(Icons.chevron_right,
                                  color: Colors.white70),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PublicUserProfilePage(
                                        userId: users[i].id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
