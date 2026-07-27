import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LeadService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createLead({
    required String title,
    required String category,
    required String description,
    required String price,
  }) async {
    Position pos = await Geolocator.getCurrentPosition();

    await _db.collection('primex_leads').add({
      'title': title,
      'category': category,
      'description': description,
      'price': price,
      'lat': pos.latitude,
      'lng': pos.longitude,
      'createdAt': Timestamp.now(),
    });
  }
}
