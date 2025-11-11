import 'package:brsm_id/screens/signup.dart';
import 'package:brsm_id/service/reset_password_email.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});

  final TextEditingController emcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 246, 247, 246),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/images/brsm.png',
              height: 120,
              width: 120,
              ),

              SizedBox(height: 30),
            
              Text('Введите email для смены пароля',
              style: TextStyle(
                fontFamily: 'montserrat',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              ),

               SizedBox(height: 30),

              TextField(
                 controller: emcontroller,
                 cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Введите email',
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
              
              SizedBox(height: 30),

              ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 199, 130),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                      
                      fontFamily: 'montserrat',
                    ),
                  ),
  onPressed: () async {
    bool success = await resetPassword(emcontroller.text);
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Письмо отправлено")),
      );
      
      Navigator.push(context, MaterialPageRoute(builder:(context) => SignUpPage()));
    
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка отправки письма")),
      );
    }
  },
  child: const Text(
                    'Сменить пароль',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17,

                    )
  )
)


                

             
            ],
          ),
          ),
        ) ,
      )
    );
  }
}