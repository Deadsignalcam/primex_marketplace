import 'package:flutter/material.dart';
import 'primex_safe_contact_buttons.dart';

class PrimeXContactActionBar extends StatelessWidget {
  final Map<String, dynamic> data;
  const PrimeXContactActionBar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PrimeXSafeContactButtons(
      receiverId: (data['ownerUid'] ??
              data['userId'] ??
              data['sellerUid'] ??
              data['uid'] ??
              '')
          .toString(),
      receiverName: (data['ownerName'] ??
              data['displayName'] ??
              data['sellerName'] ??
              'PrimeX Member')
          .toString(),
      receiverPhoto:
          (data['ownerPhoto'] ?? data['photoUrl'] ?? data['avatarUrl'] ?? '')
              .toString(),
      sourceTitle: (data['title'] ?? 'PrimeX Contact').toString(),
      listingId: (data['listingId'] ?? data['id'] ?? '').toString(),
      zoomUrl: (data['zoomUrl'] ?? data['zoomLink'] ?? data['ownerZoom'] ?? '')
          .toString(),
    );
  }
}
