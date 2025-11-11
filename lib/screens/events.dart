import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Event {
  final String title;
  final String date;
  final String imageURL;

  Event({required this.title, required this.date, required this.imageURL});
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String? selectedValue;

  final List<String> items = [
    'Минская',
    'Гродненская',
    'Витебская',
    'Могилевская',
    'Брестская',
    'Гомельская',
  ];

  final List<Event> events = [
    Event(
      title: "Доброе Сердце в действии",
      date: "25 ноября 2025",
      imageURL: "https://brsm.by/images/storage/news/002665_774351_big.png",
    ),
    Event(
      title: "Волонтеры «ДоброКидс»: чистота начинается с нас!",
      date: "28 ноября 2025",
      imageURL: "https://brsm.by/images/storage/news/002665_728384_big.jpg",
    ),
  ];

  final _firestore = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Spacer(),
                DropdownButton<String>(
                  hint: const Text('Выберите область'),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                  underline: const SizedBox(),
                  value: selectedValue,
                  items: items.map((item) {
                    return DropdownMenuItem(value: item, child: Text(item));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ],
            ),
          ),

          if (selectedValue != null)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final item = events[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.imageURL.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.imageURL,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 12),

                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            item.date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                onPressed: () async {
                                  if (_user == null) return;

                                  await _firestore
                                      .collection('users')
                                      .doc(_user!.uid)
                                      .collection('my_events')
                                      .doc(item.title)
                                      .set({
                                    'title': item.title,
                                    'date': item.date,
                                    'imageURL': item.imageURL,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Добавлено в ваши события'),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Участвовать",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 116, 199, 130),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  '+ 50 Баллов',
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
              ),
            ),
        ],
      ),
    );
  }
}
