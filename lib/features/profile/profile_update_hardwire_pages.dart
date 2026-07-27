import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const bg = Color(0xFF050816);
const card = Color(0xFF0B1020);
const cyan = Colors.cyanAccent;

String _userPhoto(Map<String, dynamic> u) {
  return (u['photoUrl'] ??
          u['photoURL'] ??
          u['profilePhoto'] ??
          u['avatarUrl'] ??
          '')
      .toString();
}

Widget _field(TextEditingController c, String label, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cyan),
        ),
      ),
    ),
  );
}

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final name = TextEditingController();
  final bio = TextEditingController();
  final photoUrl = TextEditingController();
  bool uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then((d) {
      final x = d.data() ?? {};
      name.text = (x['displayName'] ?? x['name'] ?? '').toString();
      bio.text = (x['bio'] ?? x['about'] ?? '').toString();
      photoUrl.text = _userPhoto(x);
      if (mounted) setState(() {});
    });
  }

  Future<void> pickAndUploadPhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 82);
    if (picked == null) return;

    setState(() => uploadingPhoto = true);

    try {
      final bytes = await picked.readAsBytes();
      final ref = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(widget.userId)
          .child('profile_photo.jpg');

      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();

      photoUrl.text = url;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .set({
        'displayName': name.text.trim(),
        'bio': bio.text.trim(),
        'about': bio.text.trim(),
        'photoUrl': url,
        'photoURL': url,
        'profilePhoto': url,
        'avatarUrl': url,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo upload failed: $e')),
        );
      }
    }

    if (mounted) setState(() => uploadingPhoto = false);
  }

  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .set({
      'displayName': name.text.trim(),
      'name': name.text.trim(),
      'bio': bio.text.trim(),
      'about': bio.text.trim(),
      'photoUrl': photoUrl.text.trim(),
      'photoURL': photoUrl.text.trim(),
      'profilePhoto': photoUrl.text.trim(),
      'avatarUrl': photoUrl.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final photo = photoUrl.text.trim();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundColor: cyan,
                  backgroundImage: photo.isEmpty ? null : NetworkImage(photo),
                  child: photo.isEmpty
                      ? const Icon(Icons.person, color: Colors.black, size: 52)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: uploadingPhoto ? null : pickAndUploadPhoto,
                      icon: uploadingPhoto
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.camera_alt, color: cyan),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: uploadingPhoto ? null : pickAndUploadPhoto,
            icon: const Icon(Icons.photo, color: cyan),
            label: const Text('Upload Profile Photo',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 12),
          _field(name, 'Display Name'),
          _field(photoUrl, 'Profile Photo URL'),
          _field(bio, 'About / Bio', maxLines: 5),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: save,
            icon: const Icon(Icons.save),
            label: const Text('Save Profile'),
          ),
        ],
      ),
    );
  }
}

class EditListingPage extends StatefulWidget {
  final String listingId;
  final Map<String, dynamic> data;
  const EditListingPage(
      {super.key, required this.listingId, required this.data});

  @override
  State<EditListingPage> createState() => _EditListingPageState();
}

class _EditListingPageState extends State<EditListingPage> {
  late final title =
      TextEditingController(text: (widget.data['title'] ?? '').toString());
  late final price =
      TextEditingController(text: (widget.data['price'] ?? '').toString());
  late final location = TextEditingController(
      text: (widget.data['location'] ?? widget.data['city'] ?? '').toString());
  late final description = TextEditingController(
      text: (widget.data['description'] ?? widget.data['details'] ?? '')
          .toString());

  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('listings')
        .doc(widget.listingId)
        .set({
      'title': title.text.trim(),
      'price': price.text.trim(),
      'location': location.text.trim(),
      'description': description.text.trim(),
      'showOnMap': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: const Text('Edit Listing')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _field(title, 'Title'),
          _field(price, 'Price'),
          _field(location, 'Location'),
          _field(description, 'Description', maxLines: 5),
          const SizedBox(height: 20),
          ElevatedButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('Save Listing')),
        ],
      ),
    );
  }
}

class EditLiveFeedPostPage extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> data;
  const EditLiveFeedPostPage(
      {super.key, required this.postId, required this.data});

  @override
  State<EditLiveFeedPostPage> createState() => _EditLiveFeedPostPageState();
}

class _EditLiveFeedPostPageState extends State<EditLiveFeedPostPage> {
  late final text = TextEditingController(
    text: (widget.data['text'] ??
            widget.data['caption'] ??
            widget.data['title'] ??
            '')
        .toString(),
  );

  Future<void> save() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .set({
      'text': text.text.trim(),
      'caption': text.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: const Text('Edit Post')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          _field(text, 'Post Text', maxLines: 6),
          const SizedBox(height: 20),
          ElevatedButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('Save Post')),
        ],
      ),
    );
  }
}

class FollowListPage extends StatelessWidget {
  final String userId;
  final String type;
  const FollowListPage({super.key, required this.userId, required this.type});

  @override
  Widget build(BuildContext context) {
    final col = type == 'following' ? 'following' : 'followers';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: Text(type.toUpperCase())),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(col)
            .snapshots(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snap.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child: Text('Nothing here yet.',
                    style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final x = docs[i].data() as Map<String, dynamic>;
              final otherId = (x['userId'] ?? docs[i].id).toString();

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherId)
                    .get(),
                builder: (context, userSnap) {
                  final u =
                      userSnap.data?.data() as Map<String, dynamic>? ?? {};
                  final userName =
                      (u['displayName'] ?? u['name'] ?? 'PrimeX Member')
                          .toString();
                  final photo = _userPhoto(u);

                  return Card(
                    color: card,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cyan,
                        backgroundImage:
                            photo.isEmpty ? null : NetworkImage(photo),
                        child: photo.isEmpty
                            ? const Icon(Icons.person, color: Colors.black)
                            : null,
                      ),
                      title: Text(userName,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: const Text('Email hidden for privacy',
                          style: TextStyle(color: Colors.white54)),
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

class MessageInboxPage extends StatelessWidget {
  const MessageInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: bg, title: const Text('Message Inbox')),
      body: me == null
          ? const Center(
              child:
                  Text('Login first.', style: TextStyle(color: Colors.white)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants', arrayContains: me.uid)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                      child: Text('No messages yet.',
                          style: TextStyle(color: Colors.white70)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final x = docs[i].data() as Map<String, dynamic>;
                    return Card(
                      color: card,
                      child: ListTile(
                        leading: const CircleAvatar(
                            backgroundColor: cyan,
                            child: Icon(Icons.message, color: Colors.black)),
                        title: Text(
                            (x['itemTitle'] ?? 'PrimeX Chat').toString(),
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text((x['lastMessage'] ?? '').toString(),
                            style: const TextStyle(color: Colors.white54)),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
