import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashPage({super.key, required this.onAnimationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Amorin',
              style: GoogleFonts.dynaPuff(
                fontSize: 56,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 300,
              child: Lottie.asset(
                'assets/lottie/heart.json',
                controller: _controller,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().then((_) async {
                      await Future.delayed(const Duration(seconds: 3));
                      widget.onAnimationComplete();
                    });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
