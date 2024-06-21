import 'package:flutter/material.dart';

import '../../constants/others/const.dart';

class AddChat extends StatefulWidget {
  const AddChat({super.key});

  @override
  State<AddChat> createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(
        child: Text("Add Chat"),
      ),
    );
  }
}
