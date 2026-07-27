import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/primex_ai_service.dart';

class PrimeXAiAssistantPage extends StatefulWidget {
  const PrimeXAiAssistantPage({
    super.key,
    this.initialPrompt,
    this.module = 'general',
  });

  final String? initialPrompt;
  final String module;

  @override
  State<PrimeXAiAssistantPage> createState() => _PrimeXAiAssistantPageState();
}

class _PrimeXAiAssistantPageState extends State<PrimeXAiAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _sending = false;

  static const Color cyan = Color(0xFF00E5FF);
  static const Color navy = Color(0xFF031323);
  static const Color panel = Color(0xFF071E33);

  @override
  void initState() {
    super.initState();

    final prompt = widget.initialPrompt?.trim();

    if (prompt != null && prompt.isNotEmpty) {
      _controller.text = prompt;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _controller.clear();
    });

    try {
      await PrimeXAiService.instance.ask(
        prompt: prompt,
        module: widget.module,
      );

      await Future<void>.delayed(
        const Duration(milliseconds: 250),
      );

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PrimeX AI error: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: cyan),
            SizedBox(width: 10),
            Text('PrimeX AI'),
          ],
        ),
      ),
      body: user == null
          ? const Center(
              child: Text(
                'Sign in to use PrimeX AI.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Column(
              children: [
                _buildModuleBanner(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('ai_messages')
                        .orderBy('createdAt', descending: false)
                        .limitToLast(100)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Unable to load AI history:\n'
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: cyan,
                          ),
                        );
                      }

                      final documents = snapshot.data!.docs;

                      if (documents.isEmpty) {
                        return _buildWelcome();
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final data = documents[index].data();
                          final role = (data['role'] ?? 'assistant').toString();
                          final text = (data['text'] ?? '').toString();

                          return _MessageBubble(
                            text: text,
                            isUser: role == 'user',
                          );
                        },
                      );
                    },
                  ),
                ),
                _buildComposer(),
              ],
            ),
    );
  }

  Widget _buildModuleBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: panel,
        border: Border(
          bottom: BorderSide(color: cyan),
        ),
      ),
      child: Text(
        'AI mode: ${widget.module.replaceAll('_', ' ').toUpperCase()}',
        style: const TextStyle(
          color: cyan,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 30),
        const Icon(
          Icons.auto_awesome,
          color: cyan,
          size: 68,
        ),
        const SizedBox(height: 18),
        const Text(
          'Welcome to PrimeX AI',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Search PrimeX, create listings, improve job posts, '
          'prepare applications or organize inspection notes.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 26),
        _promptButton(
          'Write a marketplace listing',
          'Help me write an accurate PrimeX Marketplace listing.',
        ),
        _promptButton(
          'Find jobs or services',
          'Help me search for jobs and services on PrimeX.',
        ),
        _promptButton(
          'Prepare inspection notes',
          'Help me organize field inspection notes.',
        ),
        _promptButton(
          'Review suspicious content',
          'Help me review content for fraud or safety concerns.',
        ),
      ],
    );
  }

  Widget _promptButton(String title, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
        onPressed: () {
          _controller.text = prompt;
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: cyan),
          padding: const EdgeInsets.all(15),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: const BoxDecoration(
          color: panel,
          border: Border(
            top: BorderSide(color: Color(0x3300E5FF)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 6,
                enabled: !_sending,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Ask PrimeX AI...',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  filled: true,
                  fillColor: navy,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: cyan),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(
                      color: Color(0x6600E5FF),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              onPressed: _sending ? null : _send,
              style: IconButton.styleFrom(
                backgroundColor: cyan,
                foregroundColor: navy,
              ),
              icon: _sending
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF005A70) : const Color(0xFF0B2945),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: isUser ? const Color(0xFF00E5FF) : const Color(0x3300E5FF),
          ),
        ),
        child: SelectableText(
          text,
          style: const TextStyle(
            color: Colors.white,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
