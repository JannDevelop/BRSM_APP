
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:brsm_id/service/registr_service.dart';
import 'data.dart';
import 'reset_password.dart';
import 'main.dart';
import 'package:brsm_id/service/vhod.dart' as vhod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AuthWrapper (),
      theme: ThemeData(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();

  @override
  void dispose() {
    passwordcontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 246, 247, 246),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/brsm.png', width: 120, height: 120),
                const SizedBox(height: 40),
      
                const Text(
                  'Регистрация нового пользователя',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'montserrat',
                  ),
                ),
                const SizedBox(height: 30),
               
                //  поле ввода email
                TextField(
                  controller: emailcontroller,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Введите ваш email',
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.all( Radius.circular(10)),
                    ),
                    labelStyle: TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                     enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 200, 200, 200),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 116, 199, 130),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 20),
      
                //  поле ввода пароля
                TextField(
                  controller: passwordcontroller,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Введите ваш пароль',
                    border: OutlineInputBorder(
                       borderRadius: BorderRadius.all( Radius.circular(10)),
                    ),
                    labelStyle: TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                     enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 200, 200, 200),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 116, 199, 130),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 30),

                GestureDetector(
                   onTap: () {
                     Navigator.push(
                      context, 
                     MaterialPageRoute(builder: (context) => ResetPassword()),
                     );
                   },
                   
                   child:  Text(
                  'Нажмите, если вы забыли пароль',
                  style: TextStyle(
                    fontFamily: 'montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                  ),
                )
                ),
               
      
                const SizedBox(height: 30),

                Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 116, 199, 130),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 13,
          fontFamily: 'Montserrat=',
        ),
      ),
      onPressed: () async {
        bool success = await AuthService.registerWithEmail(
          email: emailcontroller.text.trim(),
          password: passwordcontroller.text.trim(),
          context: context,
        );
        if (success == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DataScreen()),
          );
        }
      },
      child: const Text(
        'Зарегистрироваться',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),

    const SizedBox(width: 20), 

    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 116, 199, 130),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
      ),
      onPressed: () async {
        String email = emailcontroller.text.trim();
        String password = passwordcontroller.text.trim();
        bool success = await vhod.AuthService().signInWithEmail(
          email: email,
          password:password,
          context:context,
        );
        if (success) {
          Navigator.push(
            context,
             MaterialPageRoute(builder: (context) => MainPage()),
             );
        }
      },
      child: const Text(
        'Войти',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
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
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const MainPage();
    } else {
      return const SignUpPage();
    }
  }
}

