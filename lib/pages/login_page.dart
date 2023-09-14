import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgetss/custom_button.dart';
import 'package:chat_app/widgetss/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/show_snack_bar.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});


  static String id = 'LoginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 75,
                ),
                Image.asset('assets/images/scholar.png',
                height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Scholar Chat',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 75,
                ),
                Row(
                  children: [
                    Text('LOGIN',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),

                CustomFormTextField(
                  onChanged: (dataa)
                  {
                    email = dataa;
                  },
                  hintText: 'Email',

                ),
                const SizedBox(height: 15,),
                CustomFormTextField(
                  obscureText: true,
                  onChanged: (dataa)
                  {
                    password = dataa;
                  },
                  hintText: 'Password',
                ),
                const SizedBox(height: 30,),

                CustomButton(
                  onTap: () async {
                    if(formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatPage.id, arguments: email);

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context, 'Wrong password provided for that user.');
                        }
                      } catch (e) {
                        print(e);
                        showSnackBar(context, 'there was an error');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                    else{}
                  },
                  buttonText: 'Login',
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('don\'t have an account ? ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(' Sign in',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xffC7EDE6),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }

   Future<void> loginUser() async {
     UserCredential user = await FirebaseAuth.instance
         .signInWithEmailAndPassword(email: email!, password: password!);
   }
}
