import 'package:flutter/material.dart';

class SyntaxFooter extends StatelessWidget {
  const SyntaxFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      width: double.infinity,
      height: 560,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xff00eaff),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff00eaff).withOpacity(.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.asset(
          'assets/images/syntax_phantom_footer.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
