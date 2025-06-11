import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/constants.dart';
import 'package:google/helper/showsnakbar.dart';
import 'package:google/views/chat_page.dart';
import 'package:google/views/register_page.dart';
import 'package:google/widgets/customebuttom.dart';
import 'package:google/widgets/customformtextfileds.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Loginpage extends StatefulWidget {
  Loginpage({super.key});
  static String id ="LoginPage";
  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String? email, password;

  bool Islooding = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Islooding,
      progressIndicator: CircularProgressIndicator(color: Colors.white),
      child: Scaffold(
        resizeToAvoidBottomInset: true,

        backgroundColor: kPrimaryColor,
        body: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Spacer(flex: 4),
              Image.asset(klogo),
              Text(
                "Scholar Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Pacifico',
                ),
              ),
              SizedBox(height: 30),
              Spacer(flex: 1),
              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    CustomFormTextfileds(
                      labetext: "Email",
                      onchange: (val) {
                        email = val;
                      }, obscure: false,
                    ),
                    SizedBox(height: 10),
                    CustomFormTextfileds(
                      labetext: "Password",
                      onchange: (val) {
                        password = val;
                      }, obscure: true,
                    ),
                  ],
                ),
              ),
              Customebuttom(
                text: "Login",
                color: Colors.white,
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    Islooding = true;
                    setState(() {});
                    try {
                      await loginuser();
                      Islooding = false;
                      setState(() {});
                      Navigator.pushNamed(context, ChatPage.id,arguments: email);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showsnakbar(context, 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        showsnakbar(
                          context,
                          'Wrong password provided for that user.',
                        );
                      }
                    } catch (e) {
                      showsnakbar(context, "there was an error");
                    }
                    Islooding = false;
                    setState(() {});
                  } else {}
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterPage.id);
                    },
                    child: Text(
                      " Register",
                      style: TextStyle(
                        color: Color(0xffD4EDE9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Spacer(flex: 9),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginuser() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
