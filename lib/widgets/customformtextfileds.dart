import 'package:flutter/material.dart';

class CustomFormTextfileds extends StatelessWidget {
  final String labetext;
  final bool obscure  ;
  
  Function(String)? onchange;
  CustomFormTextfileds({super.key, required this.labetext, this.onchange, required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "filed is required";
        }
      },
      obscureText: obscure,
      onChanged: onchange,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labetext,
        labelStyle: TextStyle(color: Colors.white),
        focusColor: Colors.white,
        contentPadding: EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
            style: BorderStyle.solid,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xffC0331C),
            style: BorderStyle.solid,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xffC0331C),
            style: BorderStyle.solid,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.8,
            color: Colors.white,
            style: BorderStyle.solid,
          ),
        ),
        hoverColor: Colors.white,
      ),
    );
  }
}
