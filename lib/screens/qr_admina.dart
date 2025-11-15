import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QrAdmina extends StatefulWidget {
  const QrAdmina({super.key});

  @override
  State<QrAdmina> createState() => _QrAdminaState();
}

class _QrAdminaState extends State<QrAdmina> {
  final TextEditingController eventIdController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  String? qrData;

  void generateQRCode() {
    final eventId = eventIdController.text.trim();
    final points = int.tryParse(pointsController.text.trim()) ?? 0;

    if (eventId.isEmpty || points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля корректно!")),
      );
      return;
    }

    final data = {
      "eventId": eventId,
      "points": points,
      "timestamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    setState(() {
      qrData = jsonEncode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Создание QR-кода',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: eventIdController,
              cursorColor: Color.fromARGB(255, 114, 114, 114),
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(20),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Введите название мероприятия',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelStyle: TextStyle(
                  fontFamily: 'montserrat',
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 200, 200, 200),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 116, 199, 130),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: pointsController,
              cursorColor: Color.fromARGB(255, 114, 114, 114),
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(20),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Введите количество баллов',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelStyle: TextStyle(
                  fontFamily: 'montserrat',
                  fontWeight: FontWeight.w500,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 200, 200, 200),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 116, 199, 130),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 116, 199, 130),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                ),
              ),
              onPressed: generateQRCode,
               child: Text(
                    'Создать QR код',
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,

                    ),
                  ),
            ),
            

            const SizedBox(height: 30),

            if (qrData != null) QrImageView(data: qrData!, size: 300),
          ],
        )
        ),
    );
  }
}
