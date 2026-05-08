import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const CepApp());
}

class CepApp extends StatelessWidget {
  const CepApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1D4ED8);
    const Color secondaryColor = Color(0xFF06B6D4);
    const Color tertiaryColor = Color(0xFFF97316);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: tertiaryColor,
          surface: const Color(0xFFF3F4F6),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
      home: const HomePage(),
    );
  }
}
