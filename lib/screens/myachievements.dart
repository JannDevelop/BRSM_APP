import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Myachievements extends StatelessWidget {
  const Myachievements({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Мои достижения',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('achievements')
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color:  Color.fromARGB(255, 116, 199, 130),
              ),
            );
          }

          final achievements = snapshot.data!.docs;

          if (achievements.isEmpty) {
            return const Center(child: Text("Пока нет достижений"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final data = achievements[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? "Без названия";
              final description = data['description'] ?? "";
              final icon = data['icon'] ?? "";

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // ICON
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        icon,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // TEXTS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: const TextStyle(
                              fontFamily: 'montserrat',
                              fontSize: 14,
                              color: Color.fromARGB(255, 49, 49, 49),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
