class ListingModel {
  final String id;
  final String title;
  final String price;
  final String category;
  final String location;
  final String description;
  final String sellerPhone;
  final String imageUrl;
  final String videoUrl;
  final bool saved;
  final bool boosted;
  final double lat;
  final double lng;

  ListingModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.location,
    required this.description,
    this.sellerPhone = '',
    this.imageUrl = '',
    this.videoUrl = '',
    this.saved = false,
    this.boosted = false,
    this.lat = 40.3267,
    this.lng = -78.9220,
  });

  factory ListingModel.fromMap(String id, Map<String, dynamic> data) {
    return ListingModel(
      id: id,
      title: data['title'] ?? '',
      price: data['price'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      sellerPhone: data['sellerPhone'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      saved: data['saved'] ?? false,
      boosted: data['boosted'] ?? false,
      lat: (data['lat'] ?? 40.3267).toDouble(),
      lng: (data['lng'] ?? -78.9220).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'location': location,
      'description': description,
      'sellerPhone': sellerPhone,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'saved': saved,
      'boosted': boosted,
      'lat': lat,
      'lng': lng,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}
