import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String imagePath;
  final Widget child;
  const BackgroundWidget({Key? key, required this.imagePath, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          opacity: 0.5,
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        )
      ),
      child: child,
    );
  }
}
