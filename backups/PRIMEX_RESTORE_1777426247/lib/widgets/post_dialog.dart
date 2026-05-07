import 'package:flutter/material.dart';

class PostDialog extends StatefulWidget {
  final String title;
  final String price;
  final String user;
  final List<String> images;

  const PostDialog({
    super.key,
    required this.title,
    required this.price,
    required this.user,
    required this.images,
  });

  @override
  State<PostDialog> createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {
  final TextEditingController commentCtrl = TextEditingController();
  final List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF111B2D),
      title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // images
            if (widget.images.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: widget.images.map((img) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.network(img),
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 10),

            Text(widget.price, style: const TextStyle(color: Colors.amber)),

            const Divider(color: Colors.white24),

            // comments list
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: comments.map((c) {
                  return Text(c, style: const TextStyle(color: Colors.white70));
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // add comment
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (commentCtrl.text.isNotEmpty) {
                      setState(() {
                        comments.add(commentCtrl.text);
                        commentCtrl.clear();
                      });
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        )
      ],
    );
  }
}
