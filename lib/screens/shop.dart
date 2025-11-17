import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  Future<bool> _hasReceivedBefore(String rewardId) async {
    if (_user == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('received_rewards')
        .doc(rewardId)
        .get();

    return doc.exists;
  }

  // Проверяем, хватает ли баллов
  Future<bool> _hasEnoughPoints(int cost) async {
    if (_user == null) return false;

    final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
    final points = userDoc['points'] ?? 0;

    return points >= cost;
  }

  // Получение награды
  Future<void> _claimReward(
    Map<String, dynamic> reward,
    String rewardId,
  ) async {
    if (_user == null) return;

    final cost = (reward['cost'] ?? 0).toInt();
    final oncePerUser = reward['oncePerUser'] ?? false;

    // Проверка one-time награды
    if (oncePerUser) {
      bool received = await _hasReceivedBefore(rewardId);
      if (received) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Вы уже получали этот приз")),
        );
        return;
      }
    }

    // Проверка баланса
    bool enough = await _hasEnoughPoints(cost);
    if (!enough) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Недостаточно баллов")),
      );
      return;
    }

    // Транзакция
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore.collection('users').doc(_user!.uid);
      final rewardRef =
          userRef.collection('received_rewards').doc(rewardId);

      final userSnapshot = await transaction.get(userRef);
      final currentPoints = userSnapshot['points'] ?? 0;

      if (currentPoints < cost) return;

      // Списываем баллы
      transaction.update(userRef, {"points": currentPoints - cost});

      // Добавляем награду
      transaction.set(rewardRef, {
        "rewardId": rewardId,
        "nazvanie": reward['nazvanie'],
        "cost": cost,
        "imageUrl": reward['imageUrl'],
        "couponCode": reward['couponCode'],
        "desc": reward['desc'],
        "receivedAt": FieldValue.serverTimestamp(),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Награда успешно получена!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('rewards').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Ошибка Firestore: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 116, 199, 130)));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Нет доступных наград"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final reward = doc.data() as Map<String, dynamic>;

              final rewardId = doc.id;

              final title = reward['nazvanie'] ?? 'Без названия';
              final description = reward['desc'] ?? 'Нет описания';
              final cost = reward['cost']?.toString() ?? '0';
              final imageUrl = reward['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'montserrat',
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Цена: $cost баллов",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'montserrat'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 116, 199, 130),
                            ),
                            onPressed: () =>
                                _claimReward(reward, rewardId), 
                            child: const Text(
                              "Получить",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'montserrat',
                                  fontWeight: FontWeight.bold),
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
