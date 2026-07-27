import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CallsMessagesScreen extends StatefulWidget {
  const CallsMessagesScreen({super.key});

  @override
  State<CallsMessagesScreen> createState() => _CallsMessagesScreenState();
}

class _CallsMessagesScreenState extends State<CallsMessagesScreen> {
  final picker = ImagePicker();

  final List<Map<String, dynamic>> users = [
    {"name": "Maria", "image": null},
    {"name": "Carlos", "image": null},
    {"name": "Mike", "image": null},
    {"name": "Judy", "image": null},
  ];

  Future<void> pickImage(int index) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        users[index]["image"] = File(picked.path);
      });
    }
  }

  Widget neonButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(.6),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050816),
      body: Row(
        children: [
          Container(
            width: 260,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.cyanAccent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(.4),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => pickImage(index),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 34,
                                    backgroundColor: Colors.black,
                                    backgroundImage: user["image"] != null
                                        ? FileImage(user["image"])
                                        : null,
                                    child: user["image"] == null
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.cyanAccent,
                                            size: 38,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.cyanAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            Text(
                              user["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.cyanAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(.4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "LIVE CALLS & MESSAGES",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      neonButton("Call", Icons.call),
                      const SizedBox(width: 24),
                      neonButton("Message", Icons.message),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type message...",
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.cyanAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "SEND",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
