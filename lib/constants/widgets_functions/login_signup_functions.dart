// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:project_application/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../screens/home.dart';
import '../../screens/login_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginSignupFunctions extends GetxController {
  RxString rxUsername = RxString("Initial RxString");
  var alreadyLogedin = false;
  RxBool rxAlreadyLogedin = RxBool(false);
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final AuthService _authService = GetIt.instance.get<AuthService>();

  //check logedin
  Future<void> checkLogin() async {
    print("login information Checking running");
    final sp = await SharedPreferences.getInstance();
    print("islogedin: ${sp.getBool('isLogedin')}");
    if (sp.getBool('isLogedin') == true) {
      alreadyLogedin = true;
      print("logedin : $alreadyLogedin Last User: ${sp.getString('LastUser')}");
      rxUsername.value = sp.getString('LastUser')!;
      Get.to(() => const HomeScreen());
    } else {
      alreadyLogedin = false;
      print("logedin : $alreadyLogedin");
    }
  }

  //login function
  Future<void> loginInfo(String email, String password, authService) async {
    print("login function running");
    final sp = await SharedPreferences.getInstance();
    if ((sp.getString(email) == password) ||
        (await authService.login(email, password))) {
      await sp.setBool('isLogedin', true);
      await sp.setString("LastUser", email);
      rxUsername.value = email;
      alreadyLogedin = true;

      Get.offAllNamed("homePage");

      Get.snackbar("Welcome $email", "Login Successfull!");
      print(sp.getKeys());
    } else {
      // login faied
      Get.snackbar("Login Failed.", "Please Enter valid Credentials.");
      print(sp.getKeys());
      print("login failed");
    }
  }

  //signup function
  Future<void> saveInfo(String email, String password) async {
    print("save information function running");
    final sp = await SharedPreferences.getInstance();
    if (await sp.setBool("isLogedin", true) &&
        await sp.setString(email, password) &&
        await sp.setString("LastUser", email)) {
      rxUsername.value = email;
      alreadyLogedin = true;
      Get.offAllNamed("homePage");
      Get.snackbar("Welcome $email", "Successfully Signed in.");
      print(sp.getKeys());
    } else {
      // sign in failed.
      Get.snackbar("Title", "Signin Failed.");
      print(sp.getKeys());
      print("signin failed");
    }
  }

  Future<void> logout(authService) async {
    final sp = await SharedPreferences.getInstance();
    print(sp.getKeys());
    if (await authService.logout()) {
      await sp.setBool('isLogedin', false);
      print(sp.getKeys());
      Get.offAllNamed("loginSignupPage");
    }
  }

  void logoutDilog(authService) {
    Get.defaultDialog(
      title: "Login out",
      middleText: "Are sure you want to Logout?",
      confirm: OutlinedButton(
          onPressed: () async {
            final sp = await SharedPreferences.getInstance();
            if (sp.getBool("GoogleLogin") == true) {
              googleSignOut();
            } else {
              logout(authService);
            }
          },
          child: const Text("Yes")),
      cancel: OutlinedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("No")),
    );
  }

  // ________________________________________________________________________________ //
  // ________________________________________________________________________________ //

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<void> handleGoogleSignIn() async {
    final sp = await SharedPreferences.getInstance();
    final userCredential = await signInWithGoogle();
    final user = userCredential?.user;

    if (await sp.setBool("isLogedin", true) &&
        await sp.setString("LastUser", user!.displayName as String) &&
        await sp.setBool("GoogleLogin", true)) {
      print("Last user: ${sp.getString("LastUser")}"); //--------------------
      print(
          "google login : ${sp.getBool("GoogleLogin")}"); //--------------------
      print(sp.getKeys()); //--------------------

      alreadyLogedin = true;
      rxUsername.value = user.displayName!;

      print(rxUsername.value); //--------------------
      print("islogedin: ${sp.getBool('isLogedin')}"); //--------------------
      // Handle signed-in user (e.g., navigate to a new screen)

      Get.off(() => const HomeScreen());
      print('Signed in as: ${user.displayName}');
      Get.snackbar("Welcome ${user.displayName}", "Successfully Signed in.");
    }
  }

  Future<void> googleSignOut() async {
    final sp = await SharedPreferences.getInstance();
    print(sp.getKeys());
    // sp.clear();
    print(sp.getKeys());
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    await sp.setBool('isLogedin', false);
    await sp.setBool("GoogleLogin", false);
    Get.offAll(() => const LoginSignupScreen());
  }

  // ________________________________________________________________________________ //
  // ________________________________________________________________________________ //
}
