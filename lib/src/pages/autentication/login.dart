import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterppx/src/component/my_button.dart';
import 'package:flutterppx/src/component/my_textfield.dart';
import 'package:flutterppx/src/controller/firebase_controller.dart';

class LoginPage extends StatefulWidget {
 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

 
   void signUserIn() async {

    showDialog(
    context: context,
     builder: (context){
      return const Center(
        child: CircularProgressIndicator(),
      );
     });

     try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: '${usernameController.text+'@gmail.com'}',
       password: passwordController.text);
       Navigator.pop(context);
       print('${usernameController.text+'@gmail.com'}');

     }on FirebaseAuthException catch (e){
             Navigator.pop(context);

      if (e.code == 'user-not-found'){
        wrongEmailMessage();
      }else if (e.code == 'wrong-password'){
        wrongEmailPassword();
      }
     }
   }

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
        
                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
        
                const SizedBox(height: 50),
        
                // welcome back, you've been missed!
                Text(
                  'Bienvenido a PagoPlux',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
        
                const SizedBox(height: 25),
        
                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Usuario',
                  obscureText: false,
                ),
        
                const SizedBox(height: 10),
        
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                  
                ),
        
                const SizedBox(height: 10),
        
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 25),
        
                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),
        
                const SizedBox(height: 50),
        
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 50),
        
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }




void wrongEmailMessage(){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Usuario Incorrecto'),
      );
    });
}

void wrongEmailPassword(){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Contraseña Incorrecta'),
      );
    });
}



}