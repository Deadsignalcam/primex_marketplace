import 'package:flutter/material.dart';
import '../services/listing_service.dart';

class PostListingScreen extends StatefulWidget {
  const PostListingScreen({super.key});

  @override
  State<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends State<PostListingScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final description = TextEditingController();

  String selectedCategory = 'Real Estate';
  bool loading = false;

  final categories = [
    'Real Estate',
    'Foreclosures',
    'Jobs',
    'Services',
    'Vehicles',
    'Tools',
    'Electronics',
    'Furniture',
  ];

  Future<void> publish() async {
    if (title.text.isEmpty || price.text.isEmpty) return;

    setState(() => loading = true);

    try {
      await ListingService.createListing(
        title: title.text,
        price: price.text,
        category: selectedCategory,
        country: '',
        state: '',
        county: '',
        city: '',
        address: '',
        description: description.text,
        photos: [],
      );

      title.clear();
      price.clear();
      description.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing posted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: categories
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedCategory = val);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : publish,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Publish Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
