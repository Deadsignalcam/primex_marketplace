import 'package:flutter/material.dart';
import '../features/auth/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/messages/messages_page.dart';
import '../features/profile/primex_public_profile_page.dart';

class PrimeXProfileContactBar extends StatelessWidget {
  const PrimeXProfileContactBar({
    super.key,
    required this.profile,
  });

  final Map<String, dynamic> profile;

  Future<void> callNumber(BuildContext context) async {
    final phone = (profile['phone'] ?? profile['phoneNumber'] ?? '').toString();
    if (phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number added yet.')),
      );
      return;
    }
    await launchUrl(Uri.parse('tel:$phone'));
  }

  @override
  Widget build(BuildContext context) {
    final uid =
        (profile['ownerUid'] ?? profile['sellerUid'] ?? profile['uid'] ?? '')
            .toString();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: uid.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrimeXPublicProfilePage(
                          uid: uid,
                          profile: profile,
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.person),
            label: const Text('Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MessagesPage()),
              );
            },
            icon: const Icon(Icons.message),
            label: const Text('Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => callNumber(context),
            icon: const Icon(Icons.call),
            label: const Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
