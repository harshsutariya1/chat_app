import 'package:flutter/material.dart';
import 'package:chat_app/constants/others/const.dart';

class Sender extends StatefulWidget {
  const Sender({super.key});

  @override
  State<Sender> createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(
        child: Text("Sender"),
      ),
    );
  }
}
