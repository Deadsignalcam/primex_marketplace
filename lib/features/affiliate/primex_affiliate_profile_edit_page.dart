import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PrimeXAffiliateProfileEditPage extends StatefulWidget {
  const PrimeXAffiliateProfileEditPage({super.key});

  @override
  State<PrimeXAffiliateProfileEditPage> createState() =>
      _PrimeXAffiliateProfileEditPageState();
}

class _PrimeXAffiliateProfileEditPageState
    extends State<PrimeXAffiliateProfileEditPage> {
  final name = TextEditingController();
  final photoUrl = TextEditingController();

  Uint8List? pickedBytes;
  String pickedName = '';

  bool loaded = false;
  bool saving = false;
  bool uploading = false;

  Future<void> load() async {
    if (loaded) return;
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    final a = await FirebaseFirestore.instance
        .collection('affiliates')
        .doc(u.uid)
        .get();
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(u.uid).get();

    final d = a.data() ?? {};
    final ud = userDoc.data() ?? {};

    name.text = (d['displayName'] ?? ud['displayName'] ?? u.displayName ?? '')
        .toString();
    photoUrl.text =
        (d['photoUrl'] ?? ud['photoUrl'] ?? u.photoURL ?? '').toString();

    loaded = true;
  }

  Future<void> pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      pickedBytes = result.files.single.bytes;
      pickedName = result.files.single.name;
    });
  }

  Future<String> uploadPhoto(String uid) async {
    if (pickedBytes == null) return photoUrl.text.trim();

    setState(() => uploading = true);

    final cleanName = pickedName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final path =
        'affiliate_profiles/$uid/${DateTime.now().millisecondsSinceEpoch}_$cleanName';

    final ref = FirebaseStorage.instance.ref(path);

    await ref.putData(
      pickedBytes!,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final url = await ref.getDownloadURL();

    setState(() {
      uploading = false;
      photoUrl.text = url;
    });

    return url;
  }

  Future<void> save() async {
    final u = FirebaseAuth.instance.currentUser;
    if (u == null) return;

    setState(() => saving = true);

    final uploadedUrl = await uploadPhoto(u.uid);

    final data = {
      'displayName': name.text.trim(),
      'photoUrl': uploadedUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('affiliates')
        .doc(u.uid)
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(u.uid)
        .set(data, SetOptions(merge: true));

    if (!mounted) return;
    setState(() => saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affiliate profile updated')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, snap) {
        final preview = photoUrl.text.trim();

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Edit Affiliate Profile'),
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
                child: Container(color: Colors.black.withOpacity(.72)),
              ),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: Container(
                      width: 116,
                      height: 116,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.cyanAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(.45),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: pickedBytes != null
                            ? Image.memory(
                                pickedBytes!,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              )
                            : preview.startsWith('http')
                                ? Image.network(
                                    preview,
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 62,
                                  ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: uploading ? null : pickPhoto,
                    icon: const Icon(Icons.upload_file),
                    label: Text(
                      pickedName.isEmpty
                          ? 'Upload Profile Photo From Files'
                          : 'Selected: $pickedName',
                    ),
                  ),
                  const SizedBox(height: 16),
                  field(name, 'Display Name', Icons.person),
                  field(photoUrl, 'Profile Photo URL', Icons.image),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: saving || uploading ? null : save,
                    icon: const Icon(Icons.save),
                    label: Text(
                      uploading
                          ? 'Uploading...'
                          : saving
                              ? 'Saving...'
                              : 'Save Profile',
                    ),
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
      },
    );
  }

  Widget field(TextEditingController c, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(.65),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.cyanAccent),
          ),
        ),
      ),
    );
  }
}
