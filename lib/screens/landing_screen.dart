import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youssef_starbucks/config/constants.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD3AE89),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFEFD5BF),
              radius: 100,
              backgroundImage: AssetImage('images/smartcafe.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Smart App',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                fontFamily: 'SMASH',
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Color(0xFF7C3924),
              ),
              onPressed: () {
                context.goNamed(landingScreenTwoRoute);
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}