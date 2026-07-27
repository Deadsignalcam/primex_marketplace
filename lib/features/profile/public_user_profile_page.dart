import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/primex_follow_button.dart';
import '../../widgets/primex_safe_contact_buttons.dart';
import '../auth/auth_page.dart';
import '../listings/listing_details_page.dart';
import 'edit_profile_page.dart';
import 'followers_page.dart';

class PublicUserProfilePage extends StatefulWidget {
  final String userId;
  final bool embedded;

  const PublicUserProfilePage({
    super.key,
    required this.userId,
    this.embedded = false,
  });

  @override
  State<PublicUserProfilePage> createState() => _PublicUserProfilePageState();
}

class _PublicUserProfilePageState extends State<PublicUserProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController tabs;

  String get myUid => FirebaseAuth.instance.currentUser?.uid ?? '';

  bool get isMe => myUid.isNotEmpty && myUid == widget.userId;

  @override
  void initState() {
    super.initState();

    tabs = TabController(
      length: 7,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }

  List<String> media(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.startsWith('http'))
          .toSet()
          .toList();
    }

    if (value is String && value.trim().startsWith('http')) {
      return [value.trim()];
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> loadUserItems(
    String collection,
    String type,
  ) async {
    final output = <String, Map<String, dynamic>>{};

    for (final ownerField in const [
      'ownerUid',
      'userId',
      'sellerUid',
      'uid',
      'ownerId',
      'authorId',
    ]) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where(
              ownerField,
              isEqualTo: widget.userId,
            )
            .limit(80)
            .get();

        for (final document in snapshot.docs) {
          final data = document.data();

          output['$collection/${document.id}'] = {
            ...data,
            '_id': document.id,
            '_collection': collection,
            '_type': type,
          };
        }
      } catch (_) {}
    }

    final items = output.values.toList();

    items.sort((a, b) {
      final aBoost = (a['boostPriority'] ?? a['boostRank'] ?? 0) as num;

      final bBoost = (b['boostPriority'] ?? b['boostRank'] ?? 0) as num;

      return bBoost.compareTo(aBoost);
    });

    return items;
  }

  Widget profileBackground(Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/primex_trends_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: Colors.black),
        ),
        Container(
          color: Colors.black.withValues(alpha: .72),
        ),
        child,
      ],
    );
  }

  Widget badge(
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        right: 6,
        bottom: 6,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthPage(),
      ),
      (_) => false,
    );
  }

  Widget header(
    Map<String, dynamic> userData,
  ) {
    final name = (userData['displayName'] ??
            userData['name'] ??
            FirebaseAuth.instance.currentUser?.displayName ??
            'PrimeX Member')
        .toString();

    final photo = (userData['photoUrl'] ??
            userData['profilePhotoUrl'] ??
            userData['profilePhoto'] ??
            userData['avatarUrl'] ??
            '')
        .toString();

    final bio = (userData['bio'] ?? userData['about'] ?? '').toString();

    final verified =
        userData['verified'] == true || userData['isVerified'] == true;

    final pro = userData['primeXPro'] == true ||
        userData['isPro'] == true ||
        userData['proMember'] == true;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE06111F),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF00E5FF),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: .18),
            blurRadius: 22,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF00E5FF),
            backgroundImage:
                photo.startsWith('http') ? NetworkImage(photo) : null,
            child: photo.startsWith('http')
                ? null
                : const Icon(
                    Icons.person,
                    size: 52,
                    color: Colors.black,
                  ),
          ),
          const SizedBox(height: 11),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              if (verified)
                badge(
                  'Verified Seller',
                  Icons.verified,
                  Colors.cyanAccent,
                ),
              if (pro)
                badge(
                  'PrimeX Pro',
                  Icons.workspace_premium,
                  Colors.amberAccent,
                ),
              badge(
                'Protected Account',
                Icons.shield,
                Colors.greenAccent,
              ),
            ],
          ),
          if (bio.trim().isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 13),
          if (isMe)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
                OutlinedButton.icon(
                  onPressed: logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ],
            )
          else ...[
            PrimeXFollowButton(
              ownerId: widget.userId,
            ),
            const SizedBox(height: 10),
            PrimeXSafeContactButtons(
              receiverId: widget.userId,
              receiverName: name,
              receiverPhoto: photo,
              sourceTitle: 'PrimeX Member Profile',
              zoomUrl: (userData['zoomUrl'] ?? userData['zoomLink'] ?? '')
                  .toString(),
            ),
          ],
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('followers')
                      .snapshots(),
                  builder: (_, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;

                    return profileCountButton(
                      count: count,
                      label: 'Followers',
                      type: 'followers',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.userId)
                      .collection('following')
                      .snapshots(),
                  builder: (_, snapshot) {
                    final count = snapshot.data?.docs.length ?? 0;

                    return profileCountButton(
                      count: count,
                      label: 'Following',
                      type: 'following',
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Email, phone number, date of birth, and address are private.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileCountButton({
    required int count,
    required String label,
    required String type,
  }) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FollowersPage(
              uid: widget.userId,
              title: label,
              type: type,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget itemTab(
    String collection,
    String type,
  ) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadUserItems(
        collection,
        type,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00E5FF),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Center(
            child: Text(
              'No $type items yet.',
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemCard(items[index]);
          },
        );
      },
    );
  }

  Widget itemCard(
    Map<String, dynamic> data,
  ) {
    final id = (data['_id'] ?? '').toString();

    final collection = (data['_collection'] ?? '').toString();

    final type = (data['_type'] ?? '').toString();

    final title =
        (data['title'] ?? data['text'] ?? data['caption'] ?? '$type Item')
            .toString();

    final details = (data['details'] ?? data['description'] ?? '').toString();

    final price = (data['price'] ?? '').toString();

    final photos = <String>{
      ...media(data['photoUrls']),
      ...media(data['photos']),
      ...media(data['imageUrls']),
      ...media(data['images']),
      ...media(data['mediaUrls']),
      ...media(data['photoUrl']),
      ...media(data['imageUrl']),
    }.toList();

    final location = [
      data['city'] ?? data['postCity'] ?? data['pinCity'] ?? '',
      data['state'] ?? data['postState'] ?? data['pinState'] ?? '',
    ]
        .map((value) => value.toString().trim())
        .where((value) => value.isNotEmpty)
        .join(', ');

    return Card(
      color: const Color(0xEE07111F),
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(
          color: Color(0x4400E5FF),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: collection == 'listings'
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailsPage(
                      data: data,
                      listingId: id,
                    ),
                  ),
                );
              }
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photos.isNotEmpty)
              SizedBox(
                height: 112,
                width: double.infinity,
                child: PageView.builder(
                  itemCount: photos.length,
                  itemBuilder: (_, imageIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(6),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photos[imageIndex],
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF00E5FF),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (price.isNotEmpty)
                    Text(
                      price.startsWith(r'$') ? price : '\$$price',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (location.isNotEmpty)
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  if (details.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      details,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget followersTab(String type) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection(type)
          .snapshots(),
      builder: (context, snapshot) {
        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return Center(
            child: Text(
              type == 'followers'
                  ? 'No followers yet.'
                  : 'Not following anyone yet.',
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: documents.length,
          separatorBuilder: (_, __) => const Divider(
            color: Colors.white12,
          ),
          itemBuilder: (context, index) {
            final document = documents[index];

            final data = document.data() as Map<String, dynamic>;

            final personUid = type == 'following'
                ? (data['followingId'] ?? data['userId'] ?? document.id)
                    .toString()
                : (data['followerId'] ?? data['userId'] ?? document.id)
                    .toString();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(personUid)
                  .get(),
              builder: (_, userSnapshot) {
                final personData =
                    userSnapshot.data?.data() as Map<String, dynamic>? ?? {};

                final personName = (personData['displayName'] ??
                        personData['name'] ??
                        'PrimeX Member')
                    .toString();

                final personPhoto = (personData['photoUrl'] ??
                        personData['profilePhotoUrl'] ??
                        '')
                    .toString();

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                    backgroundImage: personPhoto.startsWith('http')
                        ? NetworkImage(
                            personPhoto,
                          )
                        : null,
                    child: personPhoto.startsWith('http')
                        ? null
                        : const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                  ),
                  title: Text(
                    personName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF00E5FF),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PublicUserProfilePage(
                          userId: personUid,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget aboutTab(
    Map<String, dynamic> userData,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        infoTile(
          Icons.info,
          'About',
          (userData['bio'] ?? userData['about'] ?? 'PrimeX member.').toString(),
        ),
        infoTile(
          Icons.location_city,
          'Public Location',
          [
            userData['city'] ?? '',
            userData['state'] ?? '',
            userData['country'] ?? '',
          ]
              .map(
                (value) => value.toString().trim(),
              )
              .where(
                (value) => value.isNotEmpty,
              )
              .join(', '),
        ),
        infoTile(
          Icons.calendar_month,
          'Member Since',
          'PrimeX Marketplace Member',
        ),
      ],
    );
  }

  Widget infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: const Color(0xEE07111F),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF00E5FF),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId.trim().isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Profile not found.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final page = StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00E5FF),
            ),
          );
        }

        final userData = snapshot.data?.data() ?? <String, dynamic>{};

        return Column(
          children: [
            header(userData),
            TabBar(
              controller: tabs,
              isScrollable: true,
              indicatorColor: const Color(0xFF00E5FF),
              labelColor: const Color(0xFF00E5FF),
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(
                  icon: Icon(Icons.storefront),
                  text: 'Listings',
                ),
                Tab(
                  icon: Icon(Icons.article),
                  text: 'Posts',
                ),
                Tab(
                  icon: Icon(Icons.handyman),
                  text: 'Services',
                ),
                Tab(
                  icon: Icon(Icons.campaign),
                  text: 'Ads',
                ),
                Tab(
                  icon: Icon(Icons.groups),
                  text: 'Followers',
                ),
                Tab(
                  icon: Icon(Icons.group_add),
                  text: 'Following',
                ),
                Tab(
                  icon: Icon(Icons.info),
                  text: 'About',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabs,
                children: [
                  itemTab(
                    'listings',
                    'Listing',
                  ),
                  itemTab(
                    'posts',
                    'Post',
                  ),
                  itemTab(
                    'jobs_services',
                    'Service',
                  ),
                  itemTab(
                    'ads_promotions',
                    'Ad',
                  ),
                  followersTab('followers'),
                  followersTab('following'),
                  aboutTab(userData),
                ],
              ),
            ),
          ],
        );
      },
    );

    if (widget.embedded) {
      return profileBackground(
        SafeArea(child: page),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          isMe ? 'My PrimeX Profile' : 'Member Profile',
        ),
      ),
      body: profileBackground(page),
    );
  }
}
