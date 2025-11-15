import 'package:brsm_id/screens/ParticipantsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class spisokPage extends StatefulWidget {
  const spisokPage({super.key});

  @override
  State<spisokPage> createState() => _spisokPageState();
}

class _spisokPageState extends State<spisokPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Список мероприятий',
          style: TextStyle(
            fontFamily: 'montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              cursorColor: Color.fromARGB(255, 114, 114, 114),
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(20),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontFamily: 'montserrat',
                  color: Colors.grey[600],
                ),
                hintText: 'Поиск...',
                prefixIcon: const Icon(Icons.search),
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
              onChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('events').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color:  Color.fromARGB(255, 116, 199, 130),));
                }

                final events = snapshot.data!.docs;

                final filteredEvents = events.where((event) {
                  final title = event['title']?.toString().toLowerCase() ?? '';
                  return title.contains(searchQuery);
                }).toList();

                if (filteredEvents.isEmpty) {
                  return const Center(child: Text('Ничего не найдено'));
                }

                return ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    final eventId = event.id;
                    final title = event['title'] ?? eventId;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'montserrat'),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color:  Color.fromARGB(255, 116, 199, 130), size: 16,),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ParticipantsPage(eventId: eventId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
