import 'package:chat_app/constants/widgets_functions/chat_tile.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants/others/const.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late DatabaseService _databaseServices;
  late AuthService _authServices;

  @override
  void initState() {
    _databaseServices = GetIt.instance.get<DatabaseService>();
    _authServices = GetIt.instance.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: _appBar(),
      body: _body(),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Constants.backgroundColor,
      title: const Text(
        "Messages",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
      stream: _databaseServices.getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Unable to load data: ${snapshot.error.toString()}"),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserProfile user = users[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ChatTile(
                  userProfile: user,
                  ontap: () async {
                    final chatExists = await _databaseServices.checkChatExists(
                        _authServices.user!.uid, user.uid!);
                    print("Chat Exists:  $chatExists");

                    if (!chatExists) {
                      //Create a new chat
                      _databaseServices.createNewChat(
                        _authServices.user!.uid,
                        user.uid!,
                      );
                    }
                    Get.to(() => ChatPage(chatUser: user));
                  },
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
