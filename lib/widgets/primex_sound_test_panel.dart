import 'package:flutter/material.dart';
import '../services/primex_sound_service.dart';

class PrimeXSoundTestPanel extends StatelessWidget {
  const PrimeXSoundTestPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: PrimeXSoundService.bell,
          icon: const Icon(Icons.notifications),
          label: const Text('Test Bell'),
        ),
        ElevatedButton.icon(
          onPressed: PrimeXSoundService.message,
          icon: const Icon(Icons.message),
          label: const Text('Test Message'),
        ),
        ElevatedButton.icon(
          onPressed: PrimeXSoundService.call,
          icon: const Icon(Icons.call),
          label: const Text('Test Call'),
        ),
      ],
    );
  }
}
