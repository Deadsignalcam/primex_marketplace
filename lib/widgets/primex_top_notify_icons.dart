import 'package:flutter/material.dart';
import '../services/primex_sound_service.dart';

class PrimeXTopNotifyIcons extends StatelessWidget {
  const PrimeXTopNotifyIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Notifications',
          icon:
              const Icon(Icons.notifications_active, color: Color(0xFFFFD700)),
          onPressed: () => PrimeXSoundService.bell(),
        ),
        IconButton(
          tooltip: 'Messages',
          icon: const Icon(Icons.message, color: Color(0xFF00E5FF)),
          onPressed: () => PrimeXSoundService.message(),
        ),
      ],
    );
  }
}
