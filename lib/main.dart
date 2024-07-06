// import 'package:chat_app/constants/widgets_functions/login_signup_functions.dart';
import 'package:chat_app/screens/Chat_App/chat_app_tabbar.dart';
import 'package:chat_app/screens/api_screen_1.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/login_signup.dart';
import 'package:chat_app/screens/messages.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/utills.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthService _authService = GetIt.instance.get<AuthService>();

  final routes = {
    'homePage': (context) => const HomeScreen(),
    'loginSignupPage': (context) => const LoginSignupScreen(),
    'api1': (context) => const ApiScreen1(),
    'chatApp': (context) => const ChatApp(),
    'messages': (context) => const Messages(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      // home: const LoginSignupScreen(),
      home: _authService.checkLogin(),
    );
  }
}
