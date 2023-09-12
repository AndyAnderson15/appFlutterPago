
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterppx/src/pages/autentication/login.dart';


class FirebaseController {


   void signUserOut(){
      FirebaseAuth.instance.signOut();
   }


}
