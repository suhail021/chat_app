import 'package:flutter/material.dart';
import 'package:google/constants.dart';

class Customebuttom extends StatelessWidget {
  final String text;
  final Color color;
  VoidCallback? onTap;

  Customebuttom({
    super.key,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: MaterialButton(
        onPressed: onTap,
        textColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        minWidth: double.infinity,
        height: 45,
        color: color,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
