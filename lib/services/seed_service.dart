import 'package:cloud_firestore/cloud_firestore.dart';

class SeedService {
  static Future<void> seedDemoListings() async {
    final db = FirebaseFirestore.instance;

    final listings = [
      {
        'title': 'Johnstown Investor Property',
        'price': 145000,
        'city': 'Johnstown',
        'state': 'PA',
        'beds': 3,
        'baths': 2,
        'sqft': 1450,
        'category': 'Real Estate',
        'status': 'FOR SALE',
        'lat': 40.3267,
        'lng': -78.9220,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Cambria County Flip Deal',
        'price': 220000,
        'city': 'Johnstown',
        'state': 'PA',
        'beds': 4,
        'baths': 3,
        'sqft': 2100,
        'category': 'Real Estate',
        'status': 'FOR SALE',
        'lat': 40.3312,
        'lng': -78.9140,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Foreclosure Lead',
        'price': 89000,
        'city': 'Johnstown',
        'state': 'PA',
        'beds': 2,
        'baths': 1,
        'sqft': 980,
        'category': 'Foreclosures',
        'status': 'FORECLOSURE',
        'lat': 40.3185,
        'lng': -78.9300,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final listing in listings) {
      await db.collection('listings').add(listing);
    }
  }
}
