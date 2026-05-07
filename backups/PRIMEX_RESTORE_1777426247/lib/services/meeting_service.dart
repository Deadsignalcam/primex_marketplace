import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetingService {
  static Future<void> start(BuildContext context, String roomName) async {
    final agree = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111B2D),
        title: const Text("PrimeX Business Call Safety", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Business use only.\n\nNo dating, sexual content, harassment, discrimination, scams, threats, or illegal activity.\n\nViolations may result in account suspension and blocked re-entry through verified identity/payment profile.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Agree & Start Call")),
        ],
      ),
    );

    if (agree != true) return;

    final safe = roomName.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    final uri = Uri.parse("https://meet.jit.si/PrimeX_$safe_${DateTime.now().millisecondsSinceEpoch}");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
