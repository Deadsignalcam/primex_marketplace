import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PrimeXClipStudioPage extends StatefulWidget {
  const PrimeXClipStudioPage({super.key});

  @override
  State<PrimeXClipStudioPage> createState() => _PrimeXClipStudioPageState();
}

class _PrimeXClipStudioPageState extends State<PrimeXClipStudioPage> {
  final titleController = TextEditingController();
  final captionController = TextEditingController();

  Uint8List? videoBytes;
  String? fileName;
  VideoPlayerController? controller;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      withData: true,
    );

    if (result == null) return;

    setState(() {
      videoBytes = result.files.first.bytes;
      fileName = result.files.first.name;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    titleController.dispose();
    captionController.dispose();
    super.dispose();
  }

  InputDecoration style(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF111827),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PrimeX Clip Studio'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'CapCut-style creator for PrimeX posts, ads, and clips.',
            style: TextStyle(color: Colors.cyanAccent, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: pickVideo,
            icon: const Icon(Icons.video_library),
            label: Text(fileName == null ? 'Upload Video Clip' : fileName!),
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white12),
            ),
            child: Center(
              child: videoBytes == null
                  ? const Text(
                      'Video preview will show here',
                      style: TextStyle(color: Colors.white54),
                    )
                  : const Icon(Icons.play_circle_fill,
                      color: Colors.cyanAccent, size: 70),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: style('Clip title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: captionController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: style('Caption / description'),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cut, color: Colors.cyanAccent),
                label: const Text('Trim Coming Soon',
                    style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon:
                    const Icon(Icons.closed_caption, color: Colors.cyanAccent),
                label: const Text('Subtitles Coming Soon',
                    style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.music_note, color: Colors.cyanAccent),
                label: const Text('Music Coming Soon',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: videoBytes == null ? null : () {},
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Save Clip Draft'),
          ),
        ],
      ),
    );
  }
}
