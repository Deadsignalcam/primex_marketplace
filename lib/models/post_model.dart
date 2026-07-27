class PostModel {
  final String title;
  final String description;
  final String category;
  final String location;
  final String image;
  final double price;

  PostModel({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.image,
    required this.price,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'image': image,
      'price': price,
    };
  }
}
