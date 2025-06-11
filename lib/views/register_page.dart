import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/constants.dart';
import 'package:google/helper/showsnakbar.dart';
import 'package:google/views/chat_page.dart';
import 'package:google/views/loginpage.dart';
import 'package:google/widgets/customebuttom.dart';
import 'package:google/widgets/customformtextfileds.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});
  static String id = "register";
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  bool Islooding = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(color: Colors.white),
      inAsyncCall: Islooding,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kPrimaryColor,
        body: Form(
          key: formkey,
          child: ListView(
            children: [
              SizedBox(height: 30),
              Image.asset(klogo, height: 100, width: 100),
              Text(
                textAlign: TextAlign.center,
                "Scholar Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Pacifico',
                ),
              ),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    CustomFormTextfileds(
                      labetext: "Email",
                      onchange: (data) {
                        email = data;
                      }, obscure: false,
                    ),
                    SizedBox(height: 10),
                    CustomFormTextfileds(
                      labetext: "Password",
                      onchange: (data) {
                        password = data;
                      }, obscure: true,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Customebuttom(
                text: "Register",
                color: Colors.white,
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    Islooding = true;
                    setState(() {});
                    Navigator.pushNamed(context, Loginpage.id);
                    try {
                      await registerUser();
                      Navigator.pushNamed(context, ChatPage.id);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showsnakbar(
                          context,
                          "The password provided is too weak.",
                        );
                      } else if (e.code == 'email-already-in-use') {
                        showsnakbar(context, "email-already-in-use");
                      }
                    } catch (e) {
                      showsnakbar(context, "there was an error");
                    }
                    Islooding = false;
                    setState(() {});
                  } else {}
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Loginpage.id);
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        color: Color(0xffD4EDE9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
