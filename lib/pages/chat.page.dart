import 'dart:math';

import 'package:amorin/services/openai.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChatPage> {
  final _chatController = InMemoryChatController();
  final openAiService = OpenAiService();
  bool _hasGreeted = false;

  @override
  void initState() {
    super.initState();
    // Send initial greeting when the chat page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasGreeted) {
        _sendGreeting();
        _hasGreeted = true;
      }
    });
  }

  void _sendGreeting() {
    final greetingMessage = TextMessage(
      id: '${Random().nextInt(1000) + 1}',
      authorId: 'assistant',
      createdAt: DateTime.now().toUtc(),
      text: 'Hello! How are you today? 😊',
    );
    _chatController.insertMessage(greetingMessage);
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      chatController: _chatController,
      currentUserId: 'user1',
      theme: ChatTheme(
        colors: ChatColors(
          primary: Color(0xFF6B4EFF),
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xff101010),
          surfaceContainerLow: Color.from(
            alpha: 1,
            red: 0.98,
            green: 0.98,
            blue: 0.98,
          ),
          surfaceContainer: Color(0xFFF5F5F5),
          surfaceContainerHigh: Color(0xFFEEEEEE),
        ),
        typography: ChatTypography.standard(),
        shape: BorderRadius.all(Radius.circular(20)),
      ),
      onMessageSend: (text) async {
        _chatController.insertMessage(_buildMessage(text, 'user1'));
        final responseText = await openAiService.sendMessage(text);
        _chatController.insertMessage(_buildMessage(responseText, 'assistant'));
      },
      resolveUser: (UserID id) async {
        return User(id: id, name: 'John Doe');
      },
    );
  }

  TextMessage _buildMessage(String text, String userId) {
    return TextMessage(
      id: '${Random().nextInt(1000) + 1}',
      authorId: userId,
      createdAt: DateTime.now().toUtc(),
      text: text,
    );
  }
}
