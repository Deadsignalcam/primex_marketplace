class PostModel {
  final String id;
  final String category;
  final String subCategory;
  final String title;
  final String price;
  final String city;
  final String state;
  final double lat;
  final double lng;
  final List<String> images;

  PostModel({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.title,
    required this.price,
    required this.city,
    required this.state,
    required this.lat,
    required this.lng,
    required this.images,
  });
}
