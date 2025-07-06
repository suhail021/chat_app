import 'package:flutter/material.dart';
import 'package:google/features/home/view/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff1F2329),appBarTheme: AppBarTheme(color: Color(0xff1F2329))),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
