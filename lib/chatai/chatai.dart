import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// ChatController using ChangeNotifier
class ChatController extends ChangeNotifier {
  List<ChatMessage> messages = [];

  final String apiKey = 'AIzaSyCKOeYxzHf6rfMpScJdeVRxl1sfjlSO7ac';
  late final GenerativeModel model;

  ChatController() {
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  void sendMessage(String text, Function updateUI) async {
    messages.add(ChatMessage(isUser: true, text: text));
    notifyListeners();

    updateUI(); // This will update the UI when the user sends the message

    final response = await _fetchResponseFromAI(text);
    if (response != null) {
      messages.add(ChatMessage(isUser: false, text: response));
      notifyListeners();

      updateUI(); // This will update the UI after AI's response is received
    }
  }

  Future<String?> _fetchResponseFromAI(String text) async {
    try {
      final content = [Content.text(text)];
      final response = await model.generateContent(content);
      return response.text;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

class ChatMessage {
  final bool isUser;
  final String text;

  ChatMessage({required this.isUser, required this.text});
}

// ChatAiScreen using ChangeNotifier and StatefulWidget
class ChatAiScreen extends StatefulWidget {
  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  late ChatController chatController;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController = ChatController(); // Initialize the chat controller
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('ChatAI'),
      // ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return message.isUser
                    ? UserMessageCard(message: message.text)
                    : AIMessageCard(message: message.text);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = messageController.text;
                    if (text.isNotEmpty) {
                      chatController.sendMessage(text, () {
                        setState(
                            () {}); // Updates the UI immediately after each event
                        _scrollToBottom();
                      });
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message Cards
class UserMessageCard extends StatelessWidget {
  final String message;

  const UserMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SelectableText(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class AIMessageCard extends StatelessWidget {
  final String message;

  const AIMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SelectableText(
            message,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
