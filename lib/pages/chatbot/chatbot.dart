import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/chatbot/provider/geminiprovider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        geminiApi.chat.add({
          "role": "user",
          "parts": [
            {"text": _controller.text.trim()},
          ]
        });
      });
      geminiApi.chatWithGemini();
    }
  }

  late Geminiprovider geminiApi;
  @override
  void initState() {
    geminiApi = Geminiprovider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.chat_bubble_outline),
            SizedBox(width: 8),
            Text("AI Chatbot"),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background.webp'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              ListenableBuilder(
                  listenable: geminiApi,
                  builder: (context, widget) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: geminiApi.chat.length,
                        itemBuilder: (context, index) {
                          final isUser =
                              geminiApi.chat[index]['role'] == 'user';
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Colors.blueAccent
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    geminiApi.chat[index]['parts'][0]['text'],
                                  )),
                            ),
                          );
                        },
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSubmitted: (value) {
                          _sendMessage();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        _sendMessage();
                      },
                      icon: const Icon(Icons.send),
                      // color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
