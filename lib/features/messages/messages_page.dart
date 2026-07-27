import 'package:flutter/material.dart';
import '../chat/primex_messages_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({
    super.key,
    String? receiverId,
    String? receiverName,
    String? sourceTitle,
    String? threadId,
    String? title,
  });

  @override
  Widget build(BuildContext context) {
    return const PrimeXMessagesPage();
  }
}
