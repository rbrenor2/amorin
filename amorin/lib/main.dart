import 'package:amorin/pages/main.page.dart';
import 'package:amorin/pages/questionnaire.page.dart';
import 'package:amorin/pages/splash.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env');
  runApp(const AmorinApp());
}

class AmorinApp extends StatefulWidget {
  const AmorinApp({super.key});

  @override
  State<AmorinApp> createState() => _AmorinAppState();
}

class _AmorinAppState extends State<AmorinApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amorin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _showSplash
          ? SplashPage(
              onAnimationComplete: () {
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : const QuestionnairePage(),
    );
  }
}
