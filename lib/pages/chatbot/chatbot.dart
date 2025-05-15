import 'package:flutter/material.dart';
import 'package:food_inventory_tracking_app/pages/chatbot/provider/geminiprovider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Color primaryColor = const Color(0xFF55AB55);

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
      _controller.clear();

      // Scroll to bottom after message is sent
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  late Geminiprovider geminiApi;

  @override
  void initState() {
    geminiApi = Geminiprovider();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Row(
          children: [
            Icon(
              Icons.eco_rounded,
              size: 24,
            ),
            SizedBox(width: 10),
            Text(
              "Food Assistant",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                geminiApi.chat.clear();
              });
            },
            tooltip: 'Clear chat',
          ),
        ],
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Column(
          children: [
            ListenableBuilder(
                listenable: geminiApi,
                builder: (context, widget) {
                  return Expanded(
                    child: geminiApi.chat.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.restaurant_menu,
                                    size: 80, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  "Ask me about ingredients, recipes, or inventory...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            itemCount: geminiApi.chat.length,
                            itemBuilder: (context, index) {
                              final isUser =
                                  geminiApi.chat[index]['role'] == 'user';
                              final message =
                                  geminiApi.chat[index]['parts'][0]['text'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  mainAxisAlignment: isUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isUser) ...[
                                      CircleAvatar(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.2),
                                        radius: 18,
                                        child: Icon(
                                          Icons.assistant,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isUser
                                              ? primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(18)
                                                  .copyWith(
                                            topLeft: isUser
                                                ? const Radius.circular(18)
                                                : const Radius.circular(4),
                                            topRight: isUser
                                                ? const Radius.circular(4)
                                                : const Radius.circular(18),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          message,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: isUser
                                                ? Colors.white
                                                : const Color(0xFF333333),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isUser) ...[
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        backgroundColor:
                                            primaryColor.withOpacity(0.85),
                                        radius: 18,
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                  );
                }),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          hintText: "Ask about food inventory...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.mic_rounded,
                              color: Colors.grey.shade500,
                            ),
                            onPressed: () {
                              // Voice input functionality could be added here
                            },
                          ),
                        ),
                        onSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _controller.text.isEmpty
                          ? Colors.grey.shade200
                          : primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: _controller.text.isEmpty
                          ? null
                          : [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(
                        Icons.send_rounded,
                        color: _controller.text.isEmpty
                            ? Colors.grey.shade500
                            : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
