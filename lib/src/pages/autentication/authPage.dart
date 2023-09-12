import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterppx/src/pages/autentication/login.dart';
import 'package:flutterppx/src/pages/demoppx.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          if (snapshot.hasData){
            return PayboxDemoPage();

          }else{

            return LoginPage();
          }

        }

      ),
    );
  }
}