import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
                                        child: MarkdownBody(
                                          data: message,
                                          selectable: true,
                                          styleSheet: isUser
                                              ? MarkdownStyleSheet(
                                                  p: const TextStyle(
                                                      color: Colors.white),
                                                  strong: const TextStyle(
                                                      color: Colors.white),
                                                  em: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              : null,
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
            ListenableBuilder(
                listenable: geminiApi,
                builder: (context, _) {
                  if (geminiApi.loading) {
                    return const TypingIndicator();
                  }
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Color(0xFFEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(18),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                children: List.generate(3, (index) {
                  final animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        index * 0.33,
                        (index + 1) * 0.33,
                        curve: Curves.easeInOut,
                      ),
                    ),
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Transform.translate(
                      offset: Offset(0,
                          -2 * animation.value * sin(animation.value * 3.14)),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
