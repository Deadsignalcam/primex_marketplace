import 'package:flutter/material.dart';
import '../features/messages/messages_page.dart';

class PrimeXMessageButton extends StatelessWidget {
  final String? receiverId;
  final String? receiverName;
  final String? sourceTitle;

  const PrimeXMessageButton({
    super.key,
    this.receiverId,
    this.receiverName,
    this.sourceTitle,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MessagesPage(
              receiverId: receiverId,
              receiverName: receiverName,
              sourceTitle: sourceTitle,
            ),
          ),
        );
      },
      icon: const Icon(Icons.chat_bubble_outline, size: 16),
      label: const Text('Message'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF00E5FF),
        side: const BorderSide(color: Color(0xFF00E5FF)),
      ),
    );
  }
}
