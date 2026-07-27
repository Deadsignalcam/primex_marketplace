import 'package:flutter/material.dart';

class PrimeXLanguageButton extends StatefulWidget {
  const PrimeXLanguageButton({super.key});

  @override
  State<PrimeXLanguageButton> createState() => _PrimeXLanguageButtonState();
}

class _PrimeXLanguageButtonState extends State<PrimeXLanguageButton> {
  String language = 'English';

  final languages = const [
    'English',
    'Spanish / Español',
    'French / Français',
    'Portuguese / Português',
    'Arabic / العربية',
    'Hindi / हिन्दी',
    'Chinese / 中文',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: language,
      dropdownColor: Colors.black,
      style: const TextStyle(
          color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
      iconEnabledColor: const Color(0xFF00E5FF),
      items: languages.map((x) {
        return DropdownMenuItem(value: x, child: Text(x));
      }).toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() => language = v);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Language selected: $v')),
        );
      },
    );
  }
}
