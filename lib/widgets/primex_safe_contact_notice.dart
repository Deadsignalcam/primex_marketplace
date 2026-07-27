import 'package:flutter/material.dart';

class PrimeXSafeContactNotice extends StatelessWidget {
  const PrimeXSafeContactNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00E5FF)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.security, color: Color(0xFF00E5FF)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'For safety, PrimeX does not display personal emails or personal phone numbers. Use secure in-app messaging, Wi-Fi audio calls, and Wi-Fi video chat. For property purchases, use licensed title/closing professionals and verify ownership before sending money.',
              style: TextStyle(color: Colors.white70, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
