import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class VideoUploadBox extends StatefulWidget {
  const VideoUploadBox({super.key});

  @override
  State<VideoUploadBox> createState() => _VideoUploadBoxState();
}

class _VideoUploadBoxState extends State<VideoUploadBox> {
  String? videoName;

  Future<void> pickVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        videoName = result.files.first.name;
      });
    }
  }

  void deleteVideo() {
    setState(() {
      videoName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFF4DFF),
          width: 2,
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2A103F),
            Color(0xFF45105E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4DFF).withOpacity(.45),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: videoName == null
          ? Center(
              child: InkWell(
                onTap: pickVideo,
                child: const Text(
                  'ADD 1 MIN VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    'VIDEO ADDED • $videoName',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /// EDIT VIDEO
                IconButton(
                  onPressed: pickVideo,
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFF00F0FF),
                    size: 30,
                  ),
                ),

                /// DELETE VIDEO
                IconButton(
                  onPressed: deleteVideo,
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xFFFF4DFF),
                    size: 30,
                  ),
                ),
              ],
            ),
    );
  }
}
