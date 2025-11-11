import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Moipokypki extends StatefulWidget {
  const Moipokypki({super.key});

  @override
  State<Moipokypki> createState() => _MoipokypkiState();
}

class _MoipokypkiState extends State<Moipokypki> {
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: Text("Пользователь не найден")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text( 'Мои покупки',
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
         
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('received_rewards')
            .orderBy('receivedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 116, 199, 130),));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Пока нет покупок"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final nazvanie = data['nazvanie'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';
              final couponCode = data['couponCode'] ?? '';
              final receivedAt = data['receivedAt'] != null
                  ? DateFormat('dd.MM.yyyy HH:mm').format(
                      (data['receivedAt'] as Timestamp).toDate())
                  : '';
              

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      if (imageUrl != '')
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nazvanie,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text("Ваш код: $couponCode"),
                            const SizedBox(height: 4),
                            Text("Получено: $receivedAt",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
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
