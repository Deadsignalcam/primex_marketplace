import 'package:flutter/material.dart';
import '../models/category_model.dart';

const neon = Color(0xff00eaff);

class CategoriesScreen extends StatelessWidget {
  final Function(String)? onSelected;

  const CategoriesScreen({
    super.key,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      CategoryModel(title: 'Real Estate', value: 'Real Estate', image: '🏠'),
      CategoryModel(title: 'Vehicles', value: 'Vehicles', image: '🚗'),
      CategoryModel(title: 'Jobs', value: 'Jobs', image: '💼'),
      CategoryModel(title: 'Services', value: 'Services', image: '🛠'),
      CategoryModel(title: 'Foreclosures', value: 'Foreclosures', image: '📍'),
      CategoryModel(
          title: 'General Items', value: 'General Items', image: '🛒'),
      CategoryModel(
          title: 'Sponsored Ads', value: 'Sponsored Ads', image: '📢'),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, i) {
        final c = categories[i];

        return GestureDetector(
          onTap: () {
            onSelected?.call(c.value);
            debugPrint("Category selected: ${c.value}");
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: neon),
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(.35),
                  Colors.blue.withOpacity(.18),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(c.image, style: const TextStyle(fontSize: 26)),
                const SizedBox(height: 10),
                Text(
                  c.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
