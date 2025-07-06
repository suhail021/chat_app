import 'package:flutter/material.dart';

class CustomeImageShein extends StatelessWidget {
  const CustomeImageShein({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: AspectRatio(
        aspectRatio: 4 / 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/images/shein-logo.png"),
              fit: BoxFit.contain,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "تسوق الان من شي أن",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
