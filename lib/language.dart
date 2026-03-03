import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() =>
      _LanguagePageState();
}

class _LanguagePageState
    extends State<LanguagePage> {
  String selectedLanguage = "English";

  final List<String> languages = [
    "English",
    "Hindi",
    "Marathi",
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs =
    await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage =
          prefs.getString("language") ??
              "English";
    });
  }

  Future<void> _changeLanguage(
      String language) async {
    final prefs =
    await SharedPreferences.getInstance();
    await prefs.setString(
        "language", language);

    setState(() {
      selectedLanguage = language;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content:
        Text("$language selected"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFC5F2F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Language',
          style:
          TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme:
        const IconThemeData(
            color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// Language List
          ...languages.map(
                (language) =>
                _buildLanguageTile(
                    language),
          ),

          const Spacer(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
      String language) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(
              12),
        ),
        child: RadioListTile<String>(
          title: Text(
            language,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
          value: language,
          groupValue:
          selectedLanguage,
          activeColor:
          Colors.brown,
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(
                  value);
            }
          },
        ),
      ),
    );
  }
}