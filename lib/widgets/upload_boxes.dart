import 'dart:html' as html;
import 'package:flutter/material.dart';

class UploadBoxes extends StatefulWidget {
  const UploadBoxes({super.key});

  @override
  State<UploadBoxes> createState() => _UploadBoxesState();
}

class _UploadBoxesState extends State<UploadBoxes> {
  List<html.File> photos = [];
  html.File? video;

  Future<void> pickPhotos() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null) {
        setState(() {
          photos = files;
        });
      }
    });
  }

  Future<void> pickVideo() async {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'video/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          video = files.first;
        });
      }
    });
  }

  BoxDecoration glow(Color color) {
    return BoxDecoration(
      color: const Color(0xFF081122),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: color, width: 3),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(.7),
          blurRadius: 10,
          spreadRadius: 2,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Photos Added: ${photos.length} / 25',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: pickPhotos,
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: glow(Colors.cyanAccent),
            child: const Center(
              child: Text(
                'ADD\nMULTIPLE\nPHOTOS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        GestureDetector(
          onTap: pickVideo,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: glow(Colors.pinkAccent),
            child: Center(
              child: Text(
                video == null ? 'ADD 1 MIN VIDEO' : video!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
