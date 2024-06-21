import 'package:flutter/material.dart';

import '../../constants/others/const.dart';

class Receiver extends StatefulWidget {
  const Receiver({super.key});

  @override
  State<Receiver> createState() => _ReceiverState();
}

class _ReceiverState extends State<Receiver> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Center(child: Text("Receiver"),),
    );
  }
}