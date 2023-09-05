import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youssef_starbucks/widgets/background_widget.dart';
import '../config/constants.dart';

class LandingTwoScreen extends StatelessWidget {
  const LandingTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFD3AE89),
      appBar: AppBar(
        backgroundColor:Color(0xFFE8C3A7),
      ),
      body:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                backgroundColor:Color(0xFFEFD5BF),
                radius: 90,
                backgroundImage: AssetImage('images/smartcafe.png'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Enjoy your coffee',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30,fontFamily: 'SMASH'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF7C3924),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      context.pushNamed(signUpScreenRoute);
                    },
                    child: const Text('Sign Up')),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF7C3924),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () {
                      context.pushNamed(loginScreenRoute);
                    },
                    child: const Text('Login')),
              ),
            ],
          ),
        ),

    );
  }
}
