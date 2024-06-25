// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:chat_app/constants/others/const.dart';
import 'package:chat_app/services/auth_services.dart';
import 'login_signup_functions.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final controller = Get.find<LoginSignupFunctions>();
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = GetIt.instance.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        // color: const Color.fromARGB(255, 127, 190, 224),
        color: Constants.backgroundColor,
        child: Column(
          children: [
            Column(
              children: [
                const DrawerHeader(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                          "assets\\Images\\user_vector-Photoroom.png"),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    // height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Username: ${controller.rxUsername}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Card(
                    child: ListTile(
                      onTap: () {
                        print("Settings button pressed!");
                      },
                      title: const Text("Settings"),
                      leading: const SizedBox(),
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      trailing: IconButton(
                        padding: const EdgeInsets.all(15),
                        onPressed: () {
                          print("Settings button pressed!");
                        },
                        icon: const Icon(Icons.logout_outlined),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        print("logout button pressed!");
                        controller.logoutDilog(_authService);
                      },
                      title: const Text("Logout"),
                      leading: const SizedBox(),
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      trailing: IconButton(
                        padding: const EdgeInsets.all(15),
                        onPressed: () {
                          print("logout button pressed!");
                          controller.logoutDilog(_authService);
                        },
                        icon: const Icon(Icons.logout_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     const SizedBox(
                  //       width: 15,
                  //     ),
                  //     IconButton.filledTonal(
                  //       onPressed: () {
                  //         Get.changeTheme(ThemeData.light());
                  //       },
                  //       icon: const Icon(Icons.light_mode_outlined),
                  //     ),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     IconButton.filled(
                  //       onPressed: () {
                  //         Get.changeTheme(ThemeData.dark());
                  //       },
                  //       icon: const Icon(Icons.dark_mode_outlined),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
