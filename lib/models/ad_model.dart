class AdModel {
  final String id;
  final String businessName;
  final String adTitle;
  final String adMessage;
  final String phone;
  final String website;
  final String imageUrl;
  final String adType;
  final String placement;
  final String paidEmail;
  final String status;
  final String createdAt;

  AdModel({
    required this.id,
    required this.businessName,
    required this.adTitle,
    required this.adMessage,
    required this.phone,
    required this.website,
    required this.imageUrl,
    required this.adType,
    required this.placement,
    required this.paidEmail,
    required this.status,
    required this.createdAt,
  });

  factory AdModel.fromMap(String id, Map<String, dynamic> data) {
    return AdModel(
      id: id,
      businessName: data['businessName'] ?? '',
      adTitle: data['adTitle'] ?? '',
      adMessage: data['adMessage'] ?? '',
      phone: data['phone'] ?? '',
      website: data['website'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      adType: data['adType'] ?? '',
      placement: data['placement'] ?? '',
      paidEmail: data['paidEmail'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'adTitle': adTitle,
      'adMessage': adMessage,
      'phone': phone,
      'website': website,
      'imageUrl': imageUrl,
      'adType': adType,
      'placement': placement,
      'paidEmail': paidEmail,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
