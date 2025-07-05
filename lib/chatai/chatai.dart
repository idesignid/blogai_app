// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// // ChatController using ChangeNotifier
// class ChatController extends ChangeNotifier {
//   List<ChatMessage> messages = [];

//   final String apiKey = 'AIzaSyCKOeYxzHf6rfMpScJdeVRxl1sfjlSO7ac';
//   late final GenerativeModel model;

//   ChatController() {
//     model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
//   }

//   void sendMessage(String text, Function updateUI) async {
//     messages.add(ChatMessage(isUser: true, text: text));
//     notifyListeners();

//     updateUI(); // This will update the UI when the user sends the message

//     final response = await _fetchResponseFromAI(text);
//     if (response != null) {
//       messages.add(ChatMessage(isUser: false, text: response));
//       notifyListeners();

//       updateUI(); // This will update the UI after AI's response is received
//     }
//   }

//   Future<String?> _fetchResponseFromAI(String text) async {
//     try {
//       final content = [Content.text(text)];
//       final response = await model.generateContent(content);
//       return response.text;
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }
// }

// class ChatMessage {
//   final bool isUser;
//   final String text;

//   ChatMessage({required this.isUser, required this.text});
// }

// // ChatAiScreen using ChangeNotifier and StatefulWidget
// class ChatAiScreen extends StatefulWidget {
//   @override
//   _ChatAiScreenState createState() => _ChatAiScreenState();
// }

// class _ChatAiScreenState extends State<ChatAiScreen> {
//   late ChatController chatController;
//   final TextEditingController messageController = TextEditingController();
//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     chatController = ChatController(); // Initialize the chat controller
//   }

//   @override
//   void dispose() {
//     messageController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.jumpTo(scrollController.position.maxScrollExtent);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('ChatAI'),
//       // ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: scrollController,
//               itemCount: chatController.messages.length,
//               itemBuilder: (context, index) {
//                 final message = chatController.messages[index];
//                 return message.isUser
//                     ? UserMessageCard(message: message.text)
//                     : AIMessageCard(message: message.text);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     final text = messageController.text;
//                     if (text.isNotEmpty) {
//                       chatController.sendMessage(text, () {
//                         setState(
//                             () {}); // Updates the UI immediately after each event
//                         _scrollToBottom();
//                       });
//                       messageController.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Message Cards
// class UserMessageCard extends StatelessWidget {
//   final String message;

//   const UserMessageCard({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: Container(
//           padding: const EdgeInsets.all(12.0),
//           decoration: BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: SelectableText(
//             message,
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AIMessageCard extends StatelessWidget {
//   final String message;

//   const AIMessageCard({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           padding: const EdgeInsets.all(12.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[300],
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: SelectableText(
//             message,
//             style: const TextStyle(color: Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Chat message can hold streaming text OR an image
class ChatMessage {
  final bool isUser;
  String text;
  bool isStreaming;
  Uint8List? imageBytes;

  ChatMessage({
    required this.isUser,
    this.text = '',
    this.isStreaming = false,
    this.imageBytes,
  });
}

class ChatController extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  // Your Gemini API key; for production, secure this on your backend!
  final String apiKey = 'AIzaSyCKOeYxzHf6rfMpScJdeVRxl1sfjlSO7ac';
  late final GenerativeModel model;

  ChatController() {
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    _addWelcome();
  }

  void _addWelcome() {
    messages.add(ChatMessage(
      isUser: false,
      text: '👋 Welcome to BlogNews AI! How can I help today?',
    ));
    notifyListeners();
  }

  /// Sends a text prompt, streams response tokens.
  void sendMessage(String prompt) async {
    // 1) add user bubble
    messages.add(ChatMessage(isUser: true, text: prompt));
    notifyListeners();

    // 2) add AI placeholder
    final aiMsg = ChatMessage(isUser: false, isStreaming: true);
    messages.add(aiMsg);
    notifyListeners();

    try {
      // stream tokens from the text model
      await for (var token in model.generateContentStream([
        Content.text(prompt),
      ])) {
        aiMsg.text += token.text!;
        notifyListeners();
      }
    } catch (e) {
      aiMsg.text = '[Error: \$e]';
      notifyListeners();
    } finally {
      aiMsg.isStreaming = false;
      notifyListeners();
    }
  }

  /// Calls the Gemini image-generation REST endpoint,
  /// decodes base64 into bytes, and inserts into chat.
  Future<void> generateImage(String prompt) async {
    final placeholder = ChatMessage(
      isUser: false,
      text: '🖼 Generating image...',
      isStreaming: true,
    );
    messages.add(placeholder);
    notifyListeners();

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'gemini-2.0-flash-exp-image-generation:generateContent?key=\$apiKey',
    );
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt},
          ]
        }
      ],
      'config': {
        'responseModalities': ['IMAGE']
      }
    });

    try {
      final res = await http.post(uri,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final parts = json['candidates'][0]['content']['parts'] as List;
        final imgPart = parts.firstWhere(
          (p) => p['inlineData'] != null,
          orElse: () => null,
        );
        if (imgPart != null) {
          final b64 = imgPart['inlineData']['data'] as String;
          placeholder.imageBytes = base64Decode(b64);
          placeholder.text = '';
        } else {
          placeholder.text = 'No image found in response.';
        }
      } else {
        placeholder.text = 'Error \${res.statusCode}: \${res.body}';
      }
    } catch (e) {
      placeholder.text = 'Error generating image: \$e';
    } finally {
      placeholder.isStreaming = false;
      notifyListeners();
    }
  }
}

class ChatAiScreen extends StatefulWidget {
  @override
  _ChatAiScreenState createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  late ChatController _ctrl;
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _ctrl = ChatController();
    _ctrl.addListener(() {
      setState(() {}); // rebuild UI on every notifyListeners()
      _autoScroll(); // then scroll to bottom
    });
  }

  @override
  void dispose() {
    _ctrl.removeListener(() {});
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _ctrl.sendMessage(text);
    _input.clear();
  }

  void _handleImage() {
    final prompt = _input.text.trim().isEmpty
        ? 'Generate an illustrative blog header image.'
        : _input.text.trim();
    _ctrl.generateImage(prompt);
    _input.clear();
  }

  Future<void> _saveImage(Uint8List bytes) async {
    final perm = await Permission.storage.request();
    if (!perm.isGranted) return;
    final dir = await getExternalStorageDirectory();
    final file =
        File('\${dir?.path}/\${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to \${file.path}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              itemCount: _ctrl.messages.length,
              itemBuilder: (ctx, i) {
                final msg = _ctrl.messages[i];
                return msg.isUser
                    ? _UserBubble(msg.text)
                    : _AIBubble(
                        text: msg.text,
                        isStreaming: msg.isStreaming,
                        imageBytes: msg.imageBytes,
                        onDownload: msg.imageBytes != null
                            ? () => _saveImage(msg.imageBytes!)
                            : null,
                      );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // IconButton(
                //     icon: const Icon(Icons.image), onPressed: _handleImage),
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: const InputDecoration(
                      hintText: 'Type message…',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.send), onPressed: _handleSend),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble(this.text);
  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(text,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(child: Icon(Icons.person, size: 20)),
          ],
        ),
      );
}

class _AIBubble extends StatelessWidget {
  final String text;
  final bool isStreaming;
  final Uint8List? imageBytes;
  final VoidCallback? onDownload;

  const _AIBubble({
    this.text = '',
    this.isStreaming = false,
    this.imageBytes,
    this.onDownload,
  });

  @override
  Widget build(BuildContext c) => Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(child: Icon(Icons.android, size: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageBytes != null)
                    Stack(
                      children: [
                        Image.memory(imageBytes!),
                        if (onDownload != null)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(Icons.download_rounded),
                              onPressed: onDownload,
                            ),
                          ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isStreaming
                          ? Row(
                              children: const [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                SizedBox(width: 8),
                                Expanded(child: Text('…')),
                              ],
                            )
                          : SelectableText(text),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}
