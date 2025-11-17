import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String eventId;
  final String userId;
  final String userName;

  const ChatPage({
    super.key,
    required this.eventId,
    required this.userId,
    required this.userName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();


 
Future<void> sendMessage() async {
  if (_controller.text.trim().isEmpty) return;


  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(widget.userId)
      .get();

  final userName = doc.exists ? '${doc['name']} ${doc['lastname']}' : 'Unknown';

  await FirebaseFirestore.instance
      .collection('events')
      .doc(widget.eventId)
      .collection('messages')
      .add({
    'userId': widget.userId,
    'userName': userName, 
    'text': _controller.text.trim(),
    'timestamp': FieldValue.serverTimestamp(),
  });


  _controller.clear();

  Future.delayed(const Duration(milliseconds: 100), () {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:  AppBar(
        backgroundColor: Color.fromARGB(248, 246, 247, 246),

        automaticallyImplyLeading: false,
        title: Text(
          'Обсуждение',
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          /// Сообщения
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .doc(widget.eventId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['userId'] == widget.userId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Color.fromARGB(255, 136, 207, 148) : const Color.fromARGB(255, 228, 228, 228),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                              Text(
                                msg['userName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontFamily: 'montserrat',
                                ),
                              ),
                            Text(msg['text'] , style: const TextStyle( fontFamily: 'montserrat', fontWeight: FontWeight.bold)
                            
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// Поле ввода
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorWidth: 1.5,
                    cursorColor: Color.fromARGB(255, 114, 114, 114),
                    decoration: const InputDecoration(
                      hintText: "Напишите сообщение...",
                      border: InputBorder.none,
                      hintStyle: TextStyle( fontFamily: 'montserrat', fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
