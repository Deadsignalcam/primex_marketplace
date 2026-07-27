import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/primex_safe_contact_buttons.dart';
import '../profile/public_user_profile_page.dart';
import 'primex_full_photo_viewer.dart';

class PrimeXListingPreviewPage extends StatefulWidget {
  const PrimeXListingPreviewPage({
    super.key,
    required this.listing,
  });

  final Map<String, dynamic> listing;

  @override
  State<PrimeXListingPreviewPage> createState() =>
      _PrimeXListingPreviewPageState();
}

class _PrimeXListingPreviewPageState extends State<PrimeXListingPreviewPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController photoController;

  int photoIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 4,
      vsync: this,
    );

    photoController = PageController();
  }

  @override
  void dispose() {
    tabController.dispose();
    photoController.dispose();
    super.dispose();
  }

  String firstText(List<String> keys) {
    for (final key in keys) {
      final value = widget.listing[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  List<String> urls(List<String> keys) {
    final output = <String>[];

    for (final key in keys) {
      final value = widget.listing[key];

      if (value is List) {
        output.addAll(
          value
              .map((item) => item.toString().trim())
              .where((url) => url.startsWith('http')),
        );
      } else if (value is String && value.trim().startsWith('http')) {
        output.add(value.trim());
      }
    }

    return output.toSet().toList();
  }

  Widget emptyState(
    IconData icon,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white30,
              size: 70,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoRow(
    IconData icon,
    String label,
    String value,
  ) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF00E5FF),
            size: 21,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                color: Colors.white,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openVideo(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) return;

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The listing video could not be opened.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = urls([
      'photoUrls',
      'imageUrls',
      'photos',
      'images',
      'mediaUrls',
      'listingPhotos',
      'gallery',
      'photoUrl',
      'imageUrl',
      'thumbnail',
      'mediaUrl',
    ]);

    final videos = urls([
      'videoUrls',
      'videos',
      'videoUrl',
    ]);

    final title = firstText([
      'title',
      'listingTitle',
      'caption',
      'text',
      'name',
    ]);

    final price = firstText([
      'price',
      'amount',
      'listingPrice',
    ]);

    final details = firstText([
      'details',
      'description',
      'body',
      'content',
      'caption',
      'text',
    ]);

    final address = firstText([
      'address',
      'postAddress',
      'propertyAddress',
    ]);

    final city = firstText([
      'pinCity',
      'postCity',
      'postingCity',
      'city',
    ]);

    final county = firstText([
      'postCounty',
      'county',
    ]);

    final state = firstText([
      'pinState',
      'postState',
      'postingState',
      'state',
    ]);

    final country = firstText([
      'pinCountry',
      'postCountry',
      'postingCountry',
      'country',
    ]);

    final zip = firstText([
      'postZip',
      'zip',
      'postalCode',
    ]);

    final category = firstText([
      'listingCategory',
      'category',
      'type',
      'postType',
    ]);

    final sellerName = firstText([
      'ownerName',
      'sellerName',
      'displayName',
      'authorName',
      'name',
    ]);

    final sellerPhoto = firstText([
      'ownerPhoto',
      'sellerPhoto',
      'profilePhoto',
      'profilePhotoUrl',
      'avatarUrl',
    ]);

    final ownerId = firstText([
      'ownerUid',
      'userId',
      'sellerUid',
      'authorId',
      'uid',
    ]);

    final listingId = firstText([
      'listingId',
      'sourceListingId',
      'originalListingId',
      'id',
      '_documentId',
    ]);

    final zoomUrl = firstText([
      'zoomUrl',
      'zoomLink',
    ]);

    final collection = firstText([
      '_collection',
      '_feedCollection',
    ]);

    final location = [
      address,
      city,
      county,
      state,
      country,
      zip,
    ].where((value) => value.trim().isNotEmpty).join(', ');

    final safeTitle = title.isEmpty ? 'PrimeX Marketplace Item' : title;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          safeTitle,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFF00E5FF),
          labelColor: const Color(0xFF00E5FF),
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(
              icon: const Icon(Icons.photo_library),
              text: 'Photos (${photos.length})',
            ),
            const Tab(
              icon: Icon(Icons.description),
              text: 'Details',
            ),
            const Tab(
              icon: Icon(Icons.person),
              text: 'Seller',
            ),
            const Tab(
              icon: Icon(Icons.forum),
              text: 'Contact',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // --------------------------------------------------
          // PHOTOS TAB
          // --------------------------------------------------
          photos.isEmpty
              ? emptyState(
                  Icons.image_not_supported,
                  'No photos were saved with this item.',
                )
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: photoController,
                        itemCount: photos.length,
                        onPageChanged: (index) {
                          setState(() => photoIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrimeXFullPhotoViewer(
                                    photos: photos,
                                    startIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: InteractiveViewer(
                                minScale: 1,
                                maxScale: 4,
                                child: Image.network(
                                  photos[index],
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) {
                                    return emptyState(
                                      Icons.broken_image,
                                      'This photo could not be loaded.',
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF07111F),
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${photoIndex + 1} of ${photos.length} photos — tap to enlarge',
                            style: const TextStyle(
                              color: Color(0xFF00E5FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            height: 78,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: photos.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final active = photoIndex == index;

                                return InkWell(
                                  onTap: () {
                                    photoController.animateToPage(
                                      index,
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                  child: Container(
                                    width: 82,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: active
                                            ? const Color(
                                                0xFFFFD700,
                                              )
                                            : const Color(
                                                0xFF00E5FF,
                                              ),
                                        width: active ? 3 : 1,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      photos[index],
                                      fit: BoxFit.cover,
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
                        ],
                      ),
                    ),
                  ],
                ),

          // --------------------------------------------------
          // DETAILS TAB
          // --------------------------------------------------
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                safeTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (price.isNotEmpty) ...[
                const SizedBox(height: 7),
                Text(
                  price.startsWith(r'$') ? price : '\$$price',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              infoRow(
                Icons.category,
                'Category',
                category,
              ),
              infoRow(
                Icons.location_on,
                'Location',
                location,
              ),
              infoRow(
                Icons.location_city,
                'City',
                city,
              ),
              infoRow(
                Icons.map,
                'County',
                county,
              ),
              infoRow(
                Icons.flag,
                'State',
                state,
              ),
              infoRow(
                Icons.public,
                'Country',
                country,
              ),
              infoRow(
                Icons.markunread_mailbox,
                'ZIP',
                zip,
              ),
              if (collection.isNotEmpty)
                infoRow(
                  Icons.storage,
                  'Source',
                  collection.replaceAll('_', ' '),
                ),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text(
                'Full Description',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                details.isEmpty
                    ? 'No additional description was provided.'
                    : details,
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.55,
                  fontSize: 15,
                ),
              ),
              if (videos.isNotEmpty) ...[
                const SizedBox(height: 22),
                const Text(
                  'Listing Videos',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...videos.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: OutlinedButton.icon(
                          onPressed: () => openVideo(entry.value),
                          icon: const Icon(
                            Icons.play_circle,
                          ),
                          label: Text(
                            'Open Video ${entry.key + 1}',
                          ),
                        ),
                      ),
                    ),
              ],
            ],
          ),

          // --------------------------------------------------
          // SELLER TAB
          // --------------------------------------------------
          ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF07111F),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF00E5FF),
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xFF00E5FF),
                      backgroundImage: sellerPhoto.startsWith('http')
                          ? NetworkImage(sellerPhoto)
                          : null,
                      child: sellerPhoto.startsWith('http')
                          ? null
                          : const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 54,
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      sellerName.isEmpty ? 'PrimeX Member' : sellerName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Contact through PrimeX protected tools.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: ownerId.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PublicUserProfilePage(
                                      userId: ownerId,
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.account_circle),
                        label: const Text(
                          'View Seller Profile',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // --------------------------------------------------
          // CONTACT TAB
          // --------------------------------------------------
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Contact ${sellerName.isEmpty ? 'Seller' : sellerName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Use PrimeX messaging, audio calling, Zoom, Safe Meet, and Follow controls.',
                style: TextStyle(
                  color: Colors.white60,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 17),
              PrimeXSafeContactButtons(
                receiverId: ownerId,
                receiverName: sellerName.isEmpty ? 'PrimeX Member' : sellerName,
                receiverPhoto: sellerPhoto,
                sourceTitle: safeTitle,
                listingId: listingId,
                zoomUrl: zoomUrl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
