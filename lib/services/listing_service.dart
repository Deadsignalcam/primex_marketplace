import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ListingService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static CollectionReference get listings => _db.collection('listings');

  // -----------------------------
  // PHOTO UPLOAD
  // -----------------------------
  static Future<List<String>> uploadPhotos(List<Uint8List> photos) async {
    List<String> urls = [];

    for (int i = 0; i < photos.length; i++) {
      final ref = _storage.ref().child(
            'listings/photos/${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
          );

      await ref.putData(photos[i]);
      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }

  // -----------------------------
  // CREATE LISTING (STABLE MVP)
  // -----------------------------
  static Future<void> createListing({
    required String title,
    required String price,
    required String category,
    required String country,
    required String state,
    required String county,
    required String city,
    required String address,
    required String description,
    List<Uint8List> photos = const [],
  }) async {
    final photoUrls = photos.isNotEmpty ? await uploadPhotos(photos) : [];

    await listings.add({
      'title': title,
      'price': price,
      'category': category,
      'country': country,
      'state': state,
      'county': county,
      'city': city,
      'address': address,
      'description': description,
      'photoUrls': photoUrls,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': 0,
      'hearts': 0,
      'comments': 0,
    });
  }
}
