import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google/constants.dart';
import 'package:google/views/cubits/auth_cubit/auth_cubit.dart';
import 'package:google/helper/showsnakbar.dart';
import 'package:google/views/chat_page.dart';
import 'package:google/views/loginpage.dart';
import 'package:google/widgets/customebuttom.dart';
import 'package:google/widgets/customformtextfileds.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  static String id = "register";

  String? email;
  String? password;
  bool Islooding = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          Islooding = true;
        } else if (state is RegisterSuccess) {
          showsnakbar(context, "create the account successfull");
          Navigator.pushNamed(context, ChatPage.id, arguments: email);
          Islooding = false;
        } else if (state is RegisterFailure) {
          showsnakbar(context, state.errorMessage);
          Islooding = false;
        }
      },
      builder:
          (context, state) => ModalProgressHUD(
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
                            },
                            obscure: false,
                          ),
                          SizedBox(height: 10),
                          CustomFormTextfileds(
                            labetext: "Password",
                            onchange: (data) {
                              password = data;
                            },
                            obscure: true,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Customebuttom(
                      text: "Register",
                      color: Colors.white,
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          BlocProvider.of<AuthCubit>(
                            context,
                          ).registerUser(email: email!, password: password!);
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
                            Navigator.pushNamed(context, loginpage.id);
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
          ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
