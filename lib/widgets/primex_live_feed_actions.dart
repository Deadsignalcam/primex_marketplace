import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/chat/primex_chat_page.dart';

class PrimeXLiveFeedActions extends StatelessWidget {
  final String postId;
  final String ownerId;
  final String postText;

  const PrimeXLiveFeedActions({
    super.key,
    required this.postId,
    required this.ownerId,
    required this.postText,
  });

  void openMessage(BuildContext context) {
    if (ownerId.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrimeXChatPage(
          otherUserId: ownerId,
          otherName: 'PrimeX Member',
          itemId: postId,
          itemTitle: 'Live Feed Post',
        ),
      ),
    );
  }

  Future<void> sharePost(BuildContext context) async {
    final body =
        postText.trim().isEmpty ? 'PrimeX Marketplace post' : postText.trim();

    await Clipboard.setData(
      ClipboardData(text: 'PrimeX Marketplace: $body'),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied. Ready to share.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        TextButton.icon(
          onPressed: () => openMessage(context),
          icon: const Icon(Icons.message, size: 15),
          label: const Text('Message'),
        ),
        TextButton.icon(
          onPressed: () => sharePost(context),
          icon: const Icon(Icons.share, size: 15),
          label: const Text('Share'),
        ),
      ],
    );
  }
}
