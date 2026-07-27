import 'package:flutter/material.dart';
import '../services/primex_safety_service.dart';

class PrimeXReportButton extends StatelessWidget {
  final String collection;
  final String itemId;

  const PrimeXReportButton({
    super.key,
    required this.collection,
    required this.itemId,
  });

  Future<void> openReport(BuildContext context) async {
    String reason = 'Spam / Scam';

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111827),
          title: const Text('Report this item',
              style: TextStyle(color: Colors.white)),
          content: DropdownButtonFormField<String>(
            initialValue: reason,
            dropdownColor: const Color(0xFF111827),
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(
                  value: 'Spam / Scam', child: Text('Spam / Scam')),
              DropdownMenuItem(
                  value: 'Nudity / Sexual Content',
                  child: Text('Nudity / Sexual Content')),
              DropdownMenuItem(
                  value: 'Abuse / Harassment',
                  child: Text('Abuse / Harassment')),
              DropdownMenuItem(
                  value: 'Illegal / Unsafe', child: Text('Illegal / Unsafe')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => reason = v ?? reason,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await PrimeXSafetyService.reportItem(
                  collection: collection,
                  itemId: itemId,
                  reason: reason,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report sent to admin.')),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => openReport(context),
      icon: const Icon(Icons.flag, color: Colors.orangeAccent),
      label: const Text('Report', style: TextStyle(color: Colors.orangeAccent)),
    );
  }
}
