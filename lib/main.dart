import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google/cubits/Register_cubit/register_cubit.dart';
import 'package:google/cubits/chat_cubit/chat_cubit.dart';
import 'package:google/cubits/login_cubit/login_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          loginpage.id: (context) => loginpage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatPage.id: (context) => ChatPage(),
        },
        initialRoute: loginpage.id,
      ),
    );
  }
}
