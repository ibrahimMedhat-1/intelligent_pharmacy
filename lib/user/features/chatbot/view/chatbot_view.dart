import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

const String GEMINI_API_KEY = "AIzaSyDo4RJVJSWmFB_nPZrdIw3liJf9HsfD_8w";

class ChatBotPage extends StatefulWidget {
  final String? diseaseMessage;

  const ChatBotPage({super.key, this.diseaseMessage});

  @override
  State<StatefulWidget> createState() => _ChatBotPage();
}

class _ChatBotPage extends State<ChatBotPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png");

  @override
  void initState() {
    super.initState();
    if (widget.diseaseMessage != null) {
      _sendMessage(ChatMessage(
        user: ChatUser(id: '0'),
        createdAt: DateTime.now(),
        text: 'Describe ${widget.diseaseMessage ?? ' '} disease ?',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "ChatBot",
        ),
      ),
      body: _build(),
    );
  }

  Widget _build() {
    return DashChat(
        inputOptions:
            InputOptions(trailing: [IconButton(onPressed: _sendMediaMessage, icon: const Icon(Icons.image))]),
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response =
              event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response =
              event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      log("$e");
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture",
          medias: [ChatMedia(url: file.path, fileName: "", type: MediaType.image)]);
      _sendMessage(chatMessage);
    }
  }
}
