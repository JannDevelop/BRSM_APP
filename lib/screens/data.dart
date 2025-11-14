import 'package:flutter/material.dart';
import '../service/zapis_date.dart';
import 'package:brsm_id/screens/main.dart';

class DataScreen extends StatelessWidget {
   DataScreen({super.key});

     final TextEditingController nomerController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController fathernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 246, 247, 246) ,
      body:  Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/brsm.png', width: 120, height: 120),  
                const SizedBox(height: 20),

                const Text( 'Введите дополнительные данные',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'montserrat',
                  ),
                ),

                const SizedBox(height: 35),

                TextField(
                  controller: nomerController ,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Введите ваш уникальный номер',
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

                const SizedBox(height: 15),

                TextField(
                  controller: nameController,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Введите ваше имя',
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

                const SizedBox(height: 15),

                TextField(
                  controller: lastnameController,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Введите вашу фамилию',
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

                const SizedBox(height: 15),

                TextField(
                  controller: fathernameController,
                  cursorColor: Color.fromARGB(255, 114, 114, 114),
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(20),
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Введите ваше отчество',
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

                ElevatedButton (
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 199, 130),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'montserrat',
                    ),
                ),
                 onPressed:
                    // действие при нажатии кнопки
                    () async  {
                      await saveUserData (
                        nomer: nomerController.text.trim(),
                        name: nameController.text.trim(),
                        lastname: lastnameController.text.trim(),
                        fathername: fathernameController.text.trim(),
                        roles: 'user',
                      );
                      Navigator.push(context, 
                      MaterialPageRoute(builder: ( context) => MainPage() ),
                      );
                    }, 
                 child: const Text(
                    'Cохранить данные',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),

    );
  }
}