import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/primex_location_service.dart';
import 'primex_listing_preview_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapRecord {
  final String collection;
  final String id;
  final Map<String, dynamic> data;

  const _MapRecord({
    required this.collection,
    required this.id,
    required this.data,
  });

  String get key => '$collection/$id';
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  final Map<String, _MapRecord> records = {};
  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      subscriptions = [];

  final Set<String> repairing = {};

  String search = '';
  bool loading = true;
  bool repairingAll = false;

  static const collections = <String>[
    'listings',
    'posts',
    'live_feed',
    'professional_live_feed',
  ];

  @override
  void initState() {
    super.initState();
    listenToMarketplace();
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    mapController?.dispose();
    super.dispose();
  }

  void listenToMarketplace() {
    for (final collection in collections) {
      final subscription =
          FirebaseFirestore.instance.collection(collection).snapshots().listen(
        (snapshot) {
          final prefix = '$collection/';

          records.removeWhere(
            (key, value) => key.startsWith(prefix),
          );

          for (final document in snapshot.docs) {
            records['$collection/${document.id}'] = _MapRecord(
              collection: collection,
              id: document.id,
              data: {
                ...document.data(),
                '_collection': collection,
                '_documentId': document.id,
              },
            );
          }

          if (mounted) {
            setState(() => loading = false);
          }
        },
        onError: (error) {
          debugPrint(
            'PrimeX map could not read $collection: $error',
          );

          if (mounted) {
            setState(() => loading = false);
          }
        },
      );

      subscriptions.add(subscription);
    }
  }

  double? asDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  String firstText(
    Map<String, dynamic> data,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = data[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }

    return '';
  }

  List<String> mediaUrls(
    Map<String, dynamic> data,
  ) {
    final output = <String>[];

    const keys = [
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
    ];

    for (final key in keys) {
      final value = data[key];

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

  LatLng? readPosition(Map<String, dynamic> data) {
    final lat = asDouble(
      data['lat'] ?? data['latitude'] ?? data['pinLat'] ?? data['mapLat'],
    );

    final lng = asDouble(
      data['lng'] ??
          data['longitude'] ??
          data['lon'] ??
          data['pinLng'] ??
          data['mapLng'],
    );

    if (lat != null &&
        lng != null &&
        lat >= -90 &&
        lat <= 90 &&
        lng >= -180 &&
        lng <= 180) {
      return LatLng(lat, lng);
    }

    for (final key in const [
      'location',
      'geoPoint',
      'geopoint',
      'position',
      'coordinates',
      'pinLocation',
      'mapLocation',
    ]) {
      final value = data[key];

      if (value is GeoPoint) {
        return LatLng(
          value.latitude,
          value.longitude,
        );
      }

      if (value is Map) {
        final nested = Map<String, dynamic>.from(value);

        final nestedLat = asDouble(
          nested['lat'] ?? nested['latitude'],
        );

        final nestedLng = asDouble(
          nested['lng'] ?? nested['longitude'] ?? nested['lon'],
        );

        if (nestedLat != null && nestedLng != null) {
          return LatLng(nestedLat, nestedLng);
        }
      }
    }

    return null;
  }

  String city(Map<String, dynamic> data) {
    return firstText(data, const [
      'pinCity',
      'postCity',
      'postingCity',
      'city',
    ]);
  }

  String state(Map<String, dynamic> data) {
    return firstText(data, const [
      'pinState',
      'postState',
      'postingState',
      'state',
    ]);
  }

  String country(Map<String, dynamic> data) {
    return firstText(data, const [
      'pinCountry',
      'postCountry',
      'postingCountry',
      'country',
    ]);
  }

  String title(Map<String, dynamic> data) {
    return firstText(data, const [
      'title',
      'listingTitle',
      'caption',
      'text',
      'name',
    ]);
  }

  String ownerId(Map<String, dynamic> data) {
    return firstText(data, const [
      'ownerUid',
      'userId',
      'sellerUid',
      'uid',
      'authorId',
    ]);
  }

  bool visibleByStatus(Map<String, dynamic> data) {
    if (data['active'] == false || data['isActive'] == false) {
      return false;
    }

    final status = (data['status'] ?? '').toString().toLowerCase();

    if (status == 'deleted' || status == 'removed' || status == 'rejected') {
      return false;
    }

    return true;
  }

  bool matchesSearch(Map<String, dynamic> data) {
    final query = search.trim().toLowerCase();

    if (query.isEmpty) return true;

    final searchable = [
      title(data),
      city(data),
      state(data),
      country(data),
      firstText(data, const [
        'category',
        'listingCategory',
        'type',
      ]),
      firstText(data, const [
        'ownerName',
        'sellerName',
        'displayName',
      ]),
    ].join(' ').toLowerCase();

    return searchable.contains(query);
  }

  String duplicateIdentity(_MapRecord record) {
    final data = record.data;

    final existingId = firstText(
      data,
      const [
        'listingId',
        'sourceListingId',
        'originalListingId',
        'id',
      ],
    );

    if (existingId.isNotEmpty) {
      return existingId;
    }

    return [
      ownerId(data),
      title(data).toLowerCase(),
      city(data).toLowerCase(),
      state(data).toLowerCase(),
    ].join('|');
  }

  bool isMapEligible(_MapRecord record) {
    final data = record.data;

    // All canonical listing documents belong on the map.
    if (record.collection == 'listings') {
      return true;
    }

    if (data['showOnMap'] == true ||
        data['mapEnabled'] == true ||
        data['pinToMap'] == true ||
        data['postAreaEnabled'] == true) {
      return true;
    }

    // Already has valid coordinates.
    if (readPosition(data) != null) {
      return true;
    }

    final itemCity = city(data);
    final itemState = state(data);
    final itemTitle = title(data);
    final images = mediaUrls(data);

    /*
     * Older tester listings and posts did not always save a type.
     * When the record has City + State and either a title or media,
     * treat it as a real mappable marketplace record.
     */
    if (itemCity.isNotEmpty &&
        itemState.isNotEmpty &&
        (itemTitle.isNotEmpty || images.isNotEmpty)) {
      return true;
    }

    final itemType = firstText(data, const [
      'type',
      'contentType',
      'postType',
      'itemType',
      'category',
      'listingCategory',
    ]).toLowerCase();

    const mapTypes = [
      'listing',
      'property',
      'real estate',
      'real_estate',
      'foreclosure',
      'reo',
      'tax sale',
      'tax_sale',
      'auction',
      'job',
      'service',
      'lead',
      'professional',
      'vehicle',
    ];

    return mapTypes.any(
          (type) => itemType.contains(type),
        ) &&
        itemCity.isNotEmpty &&
        itemState.isNotEmpty;
  }

  String sourceListingId(Map<String, dynamic> data) {
    return firstText(data, const [
      'sourceListingId',
      'originalListingId',
      'linkedListingId',
      'listingId',
    ]);
  }

  List<_MapRecord> deduplicatedRecords() {
    final listingRecords = <String, _MapRecord>{};

    for (final record in records.values) {
      if (record.collection != 'listings') continue;

      listingRecords[record.id] = record;

      final storedId = firstText(
        record.data,
        const ['listingId', 'id'],
      );

      if (storedId.isNotEmpty) {
        listingRecords[storedId] = record;
      }
    }

    final output = <String, _MapRecord>{};

    for (final original in records.values) {
      if (!visibleByStatus(original.data)) continue;

      var record = original;

      // Feed copies frequently contain only title/photo/text.
      // Pull missing map and gallery data from their source listing.
      if (record.collection != 'listings') {
        final linkedId = sourceListingId(record.data);
        final linkedListing = listingRecords[linkedId];

        if (linkedListing != null) {
          record = _MapRecord(
            collection: linkedListing.collection,
            id: linkedListing.id,
            data: {
              ...record.data,
              ...linkedListing.data,
              '_feedCollection': original.collection,
              '_feedDocumentId': original.id,
            },
          );
        }
      }

      if (!isMapEligible(record)) {
        continue;
      }

      final identity = duplicateIdentity(record);

      if (identity.replaceAll('|', '').isEmpty) {
        output[record.key] = record;
        continue;
      }

      final existing = output[identity];

      // Prefer the complete real listing document over a feed copy.
      if (existing == null || record.collection == 'listings') {
        output[identity] = record;
      }
    }

    return output.values.toList();
  }

  Future<bool> repairPosition(_MapRecord record) async {
    if (repairing.contains(record.key)) return false;

    final postCity = city(record.data);
    final postState = state(record.data);
    final postCountry = country(record.data);

    if (postCity.isEmpty || postState.isEmpty) {
      return false;
    }

    repairing.add(record.key);

    if (mounted) setState(() {});

    try {
      final pin = await PrimeXLocationService.fromPostArea(
        city: postCity,
        state: postState,
        country: postCountry.isEmpty ? 'USA' : postCountry,
      );

      if (pin == null) return false;

      await FirebaseFirestore.instance
          .collection(record.collection)
          .doc(record.id)
          .set({
        'lat': pin.lat,
        'lng': pin.lng,
        'latitude': pin.lat,
        'longitude': pin.lng,
        'pinCity': postCity,
        'pinState': postState,
        'pinCountry': postCountry.isEmpty ? 'USA' : postCountry,
        'mapLocationSource': 'primeX_unified_map_repair',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (error) {
      debugPrint(
        'Could not repair ${record.key}: $error',
      );
      return false;
    } finally {
      repairing.remove(record.key);

      if (mounted) setState(() {});
    }
  }

  Future<void> repairAllMissing(
    List<_MapRecord> items,
  ) async {
    if (repairingAll) return;

    final missing = items
        .where(
          (record) => readPosition(record.data) == null,
        )
        .toList();

    if (missing.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Every published item already has a map pin.',
          ),
        ),
      );
      return;
    }

    setState(() => repairingAll = true);

    var repairedCount = 0;
    var failedCount = 0;

    for (final record in missing) {
      final repaired = await repairPosition(record);

      if (repaired) {
        repairedCount++;
      } else {
        failedCount++;
      }

      await Future<void>.delayed(
        const Duration(milliseconds: 250),
      );
    }

    if (!mounted) return;

    setState(() => repairingAll = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$repairedCount pins repaired'
          '${failedCount == 0 ? '.' : ' • $failedCount records need a City and State.'}',
        ),
      ),
    );
  }

  void openItem(_MapRecord record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrimeXListingPreviewPage(
          listing: {
            ...record.data,
            'id': record.id,
            'listingId': firstText(
              record.data,
              const ['listingId', 'id'],
            ).isNotEmpty
                ? firstText(
                    record.data,
                    const ['listingId', 'id'],
                  )
                : record.id,
            '_collection': record.collection,
          },
        ),
      ),
    );
  }

  Future<void> fitMarkers(Set<Marker> markers) async {
    if (mapController == null || markers.isEmpty) {
      return;
    }

    if (markers.length == 1) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          markers.first.position,
          12,
        ),
      );
      return;
    }

    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (final marker in markers.skip(1)) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    try {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          75,
        ),
      );
    } catch (_) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          markers.first.position,
          6,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading && records.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00E5FF),
          ),
        ),
      );
    }

    final items = deduplicatedRecords();

    final markers = <Marker>{};
    var missingPins = 0;

    for (final record in items) {
      final data = record.data;
      final position = readPosition(data);

      if (position == null) {
        missingPins++;
        continue;
      }

      if (!matchesSearch(data)) continue;

      final itemTitle = title(data);
      final itemCity = city(data);
      final itemState = state(data);
      final itemPrice = firstText(
        data,
        const ['price', 'amount', 'listingPrice'],
      );
      final images = mediaUrls(data);

      markers.add(
        Marker(
          markerId: MarkerId(record.key),
          position: position,
          infoWindow: InfoWindow(
            title: itemTitle.isEmpty ? 'PrimeX Marketplace' : itemTitle,
            snippet: [
              if (itemPrice.isNotEmpty) '\$$itemPrice',
              itemCity,
              itemState,
              '${images.length} photo${images.length == 1 ? '' : 's'}',
              record.collection.replaceAll('_', ' '),
            ].where((item) => item.isNotEmpty).join(' • '),
            onTap: () => openItem(record),
          ),
          onTap: () => openItem(record),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PrimeX Global Marketplace Map',
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(39.8283, -98.5795),
              zoom: 4,
            ),
            markers: markers,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: true,
            mapToolbarEnabled: true,
            compassEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;

              Future<void>.delayed(
                const Duration(milliseconds: 700),
                () {
                  if (mounted && markers.isNotEmpty) {
                    fitMarkers(markers);
                  }
                },
              );
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xEE050B14),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF00E5FF),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${items.length} marketplace items loaded • '
                    '${markers.length} pins visible'
                    '${missingPins == 0 ? '' : ' • $missingPins missing pins'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (value) {
                      setState(() => search = value);
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search listings, posts, city, state...',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF00E5FF),
                      ),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: markers.isEmpty
                              ? null
                              : () => fitMarkers(markers),
                          icon: const Icon(
                            Icons.center_focus_strong,
                          ),
                          label: const Text('Show All'),
                        ),
                      ),
                      if (missingPins > 0) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: repairingAll
                                ? null
                                : () => repairAllMissing(items),
                            icon: repairingAll
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.location_searching,
                                  ),
                            label: Text(
                              repairingAll
                                  ? 'Repairing...'
                                  : 'Repair $missingPins',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
