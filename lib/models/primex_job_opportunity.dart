import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXJobOpportunity {
  const PrimeXJobOpportunity({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.companyName,
    required this.description,
    required this.category,
    required this.opportunityType,
    required this.employmentType,
    required this.location,
    required this.payType,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.companyLogoUrl = '',
    this.minPay,
    this.maxPay,
    this.remote = false,
    this.hybrid = false,
    this.urgent = false,
    this.verified = false,
    this.sameDayPay = false,
    this.latitude,
    this.longitude,
    this.applicantCount = 0,
    this.viewCount = 0,
    this.saveCount = 0,
    this.requirements = const <String>[],
    this.benefits = const <String>[],
    this.skills = const <String>[],
  });

  final String id;
  final String ownerId;
  final String title;
  final String companyName;
  final String companyLogoUrl;
  final String description;
  final String category;

  /// job, service or gig
  final String opportunityType;

  /// fulltime, parttime, contract, temporary or one_time
  final String employmentType;

  final String location;

  /// hourly, salary, fixed, commission or negotiable
  final String payType;

  final String currency;
  final double? minPay;
  final double? maxPay;

  final bool remote;
  final bool hybrid;
  final bool urgent;
  final bool verified;
  final bool sameDayPay;

  final double? latitude;
  final double? longitude;

  final int applicantCount;
  final int viewCount;
  final int saveCount;

  final List<String> requirements;
  final List<String> benefits;
  final List<String> skills;

  /// pending, active, paused, filled, rejected or expired
  final String status;

  final DateTime createdAt;

  static double? _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static int _integer(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _stringList(dynamic value) {
    if (value is! Iterable) return const <String>[];

    return value
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  factory PrimeXJobOpportunity.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};
    final timestamp = data['createdAt'];

    return PrimeXJobOpportunity(
      id: document.id,
      ownerId:
          (data['ownerId'] ?? data['userId'] ?? data['uid'] ?? '').toString(),
      title: (data['title'] ?? data['jobTitle'] ?? 'Opportunity').toString(),
      companyName:
          (data['companyName'] ?? data['businessName'] ?? 'PrimeX Member')
              .toString(),
      companyLogoUrl:
          (data['companyLogoUrl'] ?? data['logoUrl'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      category: (data['category'] ?? 'Other').toString(),
      opportunityType: (data['opportunityType'] ?? data['type'] ?? 'job')
          .toString()
          .toLowerCase(),
      employmentType:
          (data['employmentType'] ?? 'contract').toString().toLowerCase(),
      location: (data['location'] ??
              data['address'] ??
              data['city'] ??
              'Location not provided')
          .toString(),
      payType: (data['payType'] ?? 'negotiable').toString().toLowerCase(),
      currency: (data['currency'] ?? 'USD').toString().toUpperCase(),
      minPay: _number(data['minPay'] ?? data['pay'] ?? data['hourlyPay']),
      maxPay: _number(data['maxPay']),
      remote: data['remote'] == true,
      hybrid: data['hybrid'] == true,
      urgent: data['urgent'] == true,
      verified: data['verified'] == true ||
          data['companyVerified'] == true ||
          data['isVerified'] == true,
      sameDayPay: data['sameDayPay'] == true,
      latitude: _number(data['latitude'] ?? data['lat']),
      longitude: _number(data['longitude'] ?? data['lng']),
      applicantCount: _integer(data['applicantCount']),
      viewCount: _integer(data['viewCount'] ?? data['views']),
      saveCount: _integer(data['saveCount'] ?? data['saves']),
      requirements: _stringList(data['requirements']),
      benefits: _stringList(data['benefits']),
      skills: _stringList(data['skills']),
      status: (data['status'] ?? 'active').toString().toLowerCase(),
      createdAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(timestamp?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'userId': ownerId,
      'title': title.trim(),
      'companyName': companyName.trim(),
      'companyLogoUrl': companyLogoUrl.trim(),
      'description': description.trim(),
      'category': category,
      'opportunityType': opportunityType,
      'employmentType': employmentType,
      'location': location.trim(),
      'payType': payType,
      'currency': currency,
      'minPay': minPay,
      'maxPay': maxPay,
      'remote': remote,
      'hybrid': hybrid,
      'urgent': urgent,
      'verified': verified,
      'sameDayPay': sameDayPay,
      'latitude': latitude,
      'longitude': longitude,
      'applicantCount': applicantCount,
      'viewCount': viewCount,
      'saveCount': saveCount,
      'requirements': requirements,
      'benefits': benefits,
      'skills': skills,
      'status': status,
      'source': 'primex_jobs_services',
      'pinType': opportunityType == 'service'
          ? 'service'
          : opportunityType == 'gig'
              ? 'gig'
              : 'job',
      'searchTokens': _searchTokens(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  List<String> _searchTokens() {
    final content = <String>[
      title,
      companyName,
      description,
      category,
      opportunityType,
      employmentType,
      location,
      ...skills,
    ].join(' ').toLowerCase();

    final words = content
        .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 1)
        .toSet()
        .toList();

    return words.take(100).toList();
  }

  String get payLabel {
    final symbol = switch (currency) {
      'USD' => r'$',
      'EUR' => '€',
      'GBP' => '£',
      'CAD' => r'C$',
      'AUD' => r'A$',
      _ => '$currency ',
    };

    if (minPay == null && maxPay == null) {
      return payType == 'negotiable'
          ? 'Pay negotiable'
          : payType.replaceAll('_', ' ');
    }

    String clean(double value) {
      return value == value.roundToDouble()
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(2);
    }

    final suffix = switch (payType) {
      'hourly' => '/hr',
      'salary' => '/year',
      'commission' => ' commission',
      _ => '',
    };

    if (minPay != null && maxPay != null && minPay != maxPay) {
      return '$symbol${clean(minPay!)}–$symbol${clean(maxPay!)}$suffix';
    }

    final amount = minPay ?? maxPay!;
    return '$symbol${clean(amount)}$suffix';
  }
}
