// ignore_for_file: avoid_print

import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/services/storage_services.dart';
import 'package:flutter/material.dart';
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
  // RxBool isLoading = RxBool(false);
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //check logedin
  Future<void> checkLogin() async {
    try {
      print("login information Checking running");
      final sp = await SharedPreferences.getInstance();
      print("islogedin: ${sp.getBool('isLogedin')}");

      if (sp.getBool('isLogedin') == true) {
        alreadyLogedin = true;
        print(
            "logedin : $alreadyLogedin Last User: ${sp.getString('LastUser')}");
        rxUsername.value = sp.getString('LastUser')!;
        Get.to(() => const HomeScreen());
      } else {
        alreadyLogedin = false;
        print("logedin : $alreadyLogedin");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  //login function
  Future<bool> loginInfo(
      String email, String password, AuthService authService) async {
    try {
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
        return true;
      } else {
        // login faied
        Get.snackbar("Login Failed.", "Please Enter valid Credentials.");
        print(sp.getKeys());
        print("login failed");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  //signup function
  Future<bool> saveInfo(
      String email, String password, AuthService authService) async {
    try {
      print("save information function running");
      final sp = await SharedPreferences.getInstance();

      if (await authService.signup(email, password)) {
        if (await sp.setBool("isLogedin", true) &&
            await sp.setString(email, password) &&
            await sp.setString("LastUser", email)) {
          rxUsername.value = email;
          alreadyLogedin = true;
          Get.offAllNamed("homePage");
          Get.snackbar("Welcome $email", "Successfully Signed in.");
          print(sp.getKeys());
          return true;
        } else {
          Get.snackbar("Error",
              "Google Authentication Passed but error in shared preferences");
          return false;
        }
      } else {
        // sign in failed.
        Get.snackbar("Title", "Signin Failed.");
        print(sp.getKeys());
        print("signin failed");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<void> logout(AuthService authService) async {
    try {
      final sp = await SharedPreferences.getInstance();
      print(sp.getKeys());
      if (await authService.logout()) {
        print("Before clearing sharedPreferences: ${sp.getKeys()}");
        sp.clear();
        print("After clearing sharedPreferences: ${sp.getKeys()}");
        await sp.setBool('isLogedin', false);
        print(sp.getKeys());
        Get.offAllNamed("loginSignupPage");
      }
    } catch (e) {
      print("Error: $e");
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
    try {
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
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<bool> handleGoogleSignIn(StorageService storageServices, DatabaseService databaseServices, AuthService authService) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final userCredential = await signInWithGoogle();
      final user = userCredential?.user;
      final uid = user?.uid;
      final pfpicUrl = user?.photoURL;
      final email = user?.email;
      final name = user?.displayName;
      print("UID: $uid, \nemail: $email, \nname: $name, \npfpic: $pfpicUrl");

      if (user != null) {
        if (await sp.setBool("isLogedin", true) &&
            await sp.setString("LastUser", user.displayName as String) &&
            await sp.setBool("GoogleLogin", true)) {
          print(
              "Last user: ${sp.getString("LastUser")}"); //--------------------
          print(
              "google login : ${sp.getBool("GoogleLogin")}"); //--------------------
          print(sp.getKeys()); //--------------------

          alreadyLogedin = true;
          rxUsername.value = user.displayName!;
          authService.user = user;

          print("--------------Download Url: $pfpicUrl :--------------");
          if (pfpicUrl != null) {
            await databaseServices.createUserProfile(
              userProfile: UserProfile(
                  uid: uid,
                  name: name,
                  pfpURL: pfpicUrl),
            );
          } else {
            throw Exception("Unable to Upload user profile picture");
          }

          // Handle signed-in user (e.g., navigate to a new screen)
          Get.off(() => const HomeScreen());
          print('Signed in as: ${user.displayName}');
          Get.snackbar(
              "Welcome ${user.displayName}", "Successfully Signed in.");
          return true;
        } else {
          Get.snackbar("Error",
              "Google Authentication Passed but error in shared preferences");
          return false;
        }
      } else {
        Get.snackbar("Error", "Google Signin Failed.");
        print("Gooogle signin failed");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<void> googleSignOut() async {
    try {
      final sp = await SharedPreferences.getInstance();
      print("Before clearing sharedPreferences: ${sp.getKeys()}");
      sp.clear();
      print("After clearing sharedPreferences: ${sp.getKeys()}");
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      await sp.setBool('isLogedin', false);
      await sp.setBool("GoogleLogin", false);
      Get.offAll(() => const LoginSignupScreen());
    } catch (e) {
      print("Error: $e");
    }
  }

  // ________________________________________________________________________________ //
  // ________________________________________________________________________________ //
}
