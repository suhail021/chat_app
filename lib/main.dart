import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google/firebase_options.dart';
import 'package:google/views/chat_page.dart';
import 'package:google/views/loginpage.dart';
import 'package:google/views/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Chatapp());
}

class Chatapp extends StatelessWidget {
  const Chatapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        Loginpage.id: (context) => Loginpage(),
        RegisterPage.id: (context) => RegisterPage(),
        ChatPage.id: (context) => ChatPage(),
      },
      initialRoute: Loginpage.id,
    );
  }
}
