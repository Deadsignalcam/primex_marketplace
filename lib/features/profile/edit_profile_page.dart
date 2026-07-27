import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final name = TextEditingController();
  final bio = TextEditingController();
  final business = TextEditingController();
  final website = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  bool loaded = false;
  bool saving = false;

  Future<void> load() async {
    if (loaded) return;
    loaded = true;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final d = doc.data() ?? {};

    name.text = (d['displayName'] ?? user.displayName ?? '').toString();
    bio.text = (d['bio'] ?? '').toString();
    business.text = (d['businessName'] ?? '').toString();
    website.text = (d['website'] ?? '').toString();
    phone.text = (d['phonePrivate'] ?? '').toString();
    address.text = (d['addressPrivate'] ?? '').toString();
  }

  Future<void> save() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => saving = true);

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'displayName': name.text.trim(),
      'bio': bio.text.trim(),
      'businessName': business.text.trim(),
      'website': website.text.trim(),
      'phonePrivate': phone.text.trim(),
      'addressPrivate': address.text.trim(),
      'emailPrivate': user.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
    Navigator.pop(context);
  }

  Widget field(String label, TextEditingController c, IconData icon,
      {int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        maxLines: lines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(.65),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.cyanAccent),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    load();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black, title: const Text('Edit Profile')),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/primex_trends_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black.withOpacity(.62)),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              field('Display Name', name, Icons.person),
              field('Bio', bio, Icons.info_outline, lines: 3),
              field('Business Name', business, Icons.business),
              field('Website', website, Icons.link),
              field('Phone Private', phone, Icons.phone),
              field('Address Private', address, Icons.location_on),
              const Text(
                'Private fields are not shown publicly. PrimeX keeps emails and phone numbers hidden.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: saving ? null : save,
                icon: const Icon(Icons.save),
                label: Text(saving ? 'Saving...' : 'Save Profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
