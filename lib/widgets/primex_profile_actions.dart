import 'package:flutter/material.dart';
import '../features/auth/login_page.dart';
import '../features/chat/primex_chat_page.dart';
import '../features/chat/primex_call_page.dart';

class PrimeXProfileActions extends StatelessWidget {
  final String userId;
  final String name;

  const PrimeXProfileActions({
    super.key,
    required this.userId,
    required this.name,
    String phone = '',
    String videoUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrimeXCallPage(
                  otherUserId: userId,
                  otherName: name,
                  video: false,
                ),
              ),
            );
          },
          icon: const Icon(Icons.call),
          label: const Text('Audio'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrimeXChatPage(
                  otherUserId: userId,
                  otherName: name,
                ),
              ),
            );
          },
          icon: const Icon(Icons.message),
          label: const Text('Message'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrimeXCallPage(
                  otherUserId: userId,
                  otherName: name,
                  video: true,
                ),
              ),
            );
          },
          icon: const Icon(Icons.videocam),
          label: const Text('Video'),
        ),
      ],
    );
  }
}
