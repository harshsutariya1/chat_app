import 'package:flutter/material.dart';
import 'package:chat_app/screens/Chat_App/add_chat.dart';
import 'package:chat_app/screens/Chat_App/receiver.dart';
import 'package:chat_app/screens/Chat_App/sender.dart';

import '../../constants/others/const.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text(
            "Chat App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Constants.backgroundColor,
          bottom: const TabBar(
            tabs: [
              Tooltip(
                message: "Sender",
                child: Tab(icon: Icon(Icons.chat_bubble_outline_rounded)),
              ),
              Tooltip(
                message: "Receiver",
                child: Tab(icon: Icon(Icons.chat_outlined)),
              ),
              Tooltip(
                message: "Add Chat",
                child: Tab(icon: Icon(Icons.add)),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Sender(),
            Receiver(),
            AddChat(),
          ],
        ),
      ),
    );
  }
}
