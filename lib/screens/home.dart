// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:chat_app/constants/re_usables/widgets.dart';
import '../constants/others/const.dart';
import '../constants/widgets_functions/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.backgroundColor,
        title: const Text(
          "Lobby",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          homeScreenButton(buttonName: "Api 1", goto: "api1"),
          homeScreenButton(buttonName: "Chat App", goto: "chatApp"),
          homeScreenButton(buttonName: "Messages", goto: "messages"),
        ],
      ),
      drawer: const MyDrawer(),
      extendBodyBehindAppBar: false,
    );
  }
}
