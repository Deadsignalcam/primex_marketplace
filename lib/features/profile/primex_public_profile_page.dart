import 'package:flutter/material.dart';
import 'public_user_profile_page.dart';

class PrimeXPublicProfilePage extends StatelessWidget {
  final String? uid;
  final String? userId;
  final Map<String, dynamic>? profile;

  const PrimeXPublicProfilePage({
    super.key,
    this.uid,
    this.userId,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final id = (userId ?? uid ?? profile?['userId'] ?? profile?['uid'] ?? '')
        .toString();

    return PublicUserProfilePage(userId: id);
  }
}
