import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleSearchWidget extends StatefulWidget {
  const PeopleSearchWidget({super.key});

  @override
  State<PeopleSearchWidget> createState() => _PeopleSearchWidgetState();
}

class _PeopleSearchWidgetState extends State<PeopleSearchWidget> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF101522),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Search People...',
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (v) {
              setState(() {
                searchText = v.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 10),
          if (searchText.isNotEmpty)
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final results = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final name =
                      (data['displayName'] ?? '').toString().toLowerCase();

                  final email = (data['email'] ?? '').toString().toLowerCase();

                  return name.contains(searchText) ||
                      email.contains(searchText);
                }).toList();

                return Column(
                  children: results.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        data['displayName'] ?? 'PrimeX User',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        data['email'] ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
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
