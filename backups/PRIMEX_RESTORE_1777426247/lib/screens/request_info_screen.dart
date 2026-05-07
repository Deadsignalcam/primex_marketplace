import 'package:flutter/material.dart';
import '../data/lead_store.dart';

class RequestInfoScreen extends StatefulWidget {
  final String propertyTitle;

  const RequestInfoScreen({super.key, required this.propertyTitle});

  @override
  State<RequestInfoScreen> createState() => _RequestInfoScreenState();
}

class _RequestInfoScreenState extends State<RequestInfoScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();

  void submit() {
    if (name.text.isEmpty || phone.text.isEmpty) return;

    LeadStore.add(
      LeadItem(
        name: name.text,
        phone: phone.text,
        email: email.text,
        property: widget.propertyTitle,
        message: message.text,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Info")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(widget.propertyTitle),
            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: message, decoration: const InputDecoration(labelText: "Message")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
