import 'package:chat_app/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.userProfile, required this.ontap});

  final UserProfile userProfile;
  final Function ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(132, 255, 255, 255),
      ),
      child: ListTile(
        onTap: () {
          ontap();
        },
        dense: false,
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(userProfile.pfpURL!),
        ),
        title: Text(
          userProfile.name!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
