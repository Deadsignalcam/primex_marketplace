import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String price;
  final double lat;
  final double lng;

  LeadModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.lat,
    required this.lng,
  });

  factory LeadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LeadModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
    );
  }
}
