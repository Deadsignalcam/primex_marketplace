import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeXAiMessage {
  const PrimeXAiMessage({
    required this.id,
    required this.text,
    required this.role,
    required this.createdAt,
    this.module = 'general',
    this.isError = false,
  });

  final String id;
  final String text;
  final String role;
  final DateTime createdAt;
  final String module;
  final bool isError;

  bool get isUser => role == 'user';

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'role': role,
      'module': module,
      'isError': isError,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PrimeXAiMessage.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final timestamp = map['createdAt'];

    return PrimeXAiMessage(
      id: id,
      text: (map['text'] ?? '').toString(),
      role: (map['role'] ?? 'assistant').toString(),
      module: (map['module'] ?? 'general').toString(),
      isError: map['isError'] == true,
      createdAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
    );
  }
}
