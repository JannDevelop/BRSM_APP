import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ParticipantsPage extends StatelessWidget {
  final String eventId;

  const ParticipantsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Участники мероприятия',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('events')
            .doc(eventId)
            .collection('participants')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 116, 199, 130),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final participants = snapshot.data?.docs ?? [];

          if (participants.isEmpty) {
            return const Center(child: Text('Нет участников'));
          }

          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index];
              final data = participant.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Без имени';
              final lastname = data['lastname'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name $lastname',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'montserrat',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'email: ${data['email'] ?? 'Нет email'}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontFamily: 'montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                116,
                                199,
                                130,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Пришел',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                116,
                                199,
                                130,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Не пришел',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
