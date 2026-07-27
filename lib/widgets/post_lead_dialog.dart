import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostLeadDialog extends StatefulWidget {
  const PostLeadDialog({super.key});

  @override
  State<PostLeadDialog> createState() => _PostLeadDialogState();
}

class _PostLeadDialogState extends State<PostLeadDialog> {
  final title = TextEditingController();
  final city = TextEditingController(text: 'Johnstown');
  final state = TextEditingController(text: 'PA');
  final price = TextEditingController();
  final beds = TextEditingController();
  final baths = TextEditingController();
  final sqft = TextEditingController();

  bool loading = false;

  Future<void> postLead() async {
    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('listings').add({
      'title': title.text.trim(),
      'city': city.text.trim(),
      'state': state.text.trim(),
      'price': int.tryParse(price.text) ?? 0,
      'beds': int.tryParse(beds.text) ?? 0,
      'baths': int.tryParse(baths.text) ?? 0,
      'sqft': int.tryParse(sqft.text) ?? 0,
      'status': 'FOR SALE',
      'category': 'Real Estate',
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (mounted) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          content: Text('Lead Posted Successfully'),
        ),
      );
    }
  }

  Widget field(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF111827),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF020617),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'POST LEAD',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              field('Property Title', title),
              field('City', city),
              field('State', state),
              field('Price', price),
              field('Bedrooms', beds),
              field('Bathrooms', baths),
              field('Square Feet', sqft),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : postLead,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'POST NOW',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
