import 'package:amorin/pages/main.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const AmorinApp());
}

class AmorinApp extends StatelessWidget {
  const AmorinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amorin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}
