import 'package:flutter/material.dart';

import '../screens/primex_ai_assistant_page.dart';

class PrimeXAiFloatingButton extends StatelessWidget {
  const PrimeXAiFloatingButton({
    super.key,
    this.module = 'general',
    this.initialPrompt,
    this.heroTag = 'primex_ai_button',
  });

  final String module;
  final String? initialPrompt;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: heroTag,
      backgroundColor: const Color(0xFF00E5FF),
      foregroundColor: const Color(0xFF031323),
      icon: const Icon(Icons.auto_awesome),
      label: const Text(
        'PrimeX AI',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PrimeXAiAssistantPage(
              module: module,
              initialPrompt: initialPrompt,
            ),
          ),
        );
      },
    );
  }
}
