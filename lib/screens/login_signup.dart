// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:chat_app/constants/others/const.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/media_services.dart';
import '../constants/widgets_functions/login_signup_functions.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? selectedImage;
  bool isLoginPage = false;
  bool formvalidation = false;
  final c = Get.find<LoginSignupFunctions>();
  late AuthService _authService;
  late MediaServices _mediaServices;

  @override
  void initState() {
    // _authService = Get.find<AuthService>();
    _authService = GetIt.instance.get<AuthService>();
    _mediaServices = GetIt.instance.get<MediaServices>();
    c.checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void formValidation() {
    if (_formKey.currentState!.validate()) {
      formvalidation = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(147, 190, 230, 215),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (isLoginPage)
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 50),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Let's Get going...",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                (isLoginPage)
                    ? Image.asset("assets/Images/171_bgremoved.png")
                    : GestureDetector(
                        onTap: () async {
                          File? file =
                              await _mediaServices.getImageFromGallery();
                          if (file != null) {
                            setState(() {
                              selectedImage = file;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          // decoration: BoxDecoration(border: Border.all()),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: MediaQuery.of(context).size.width * 0.17,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.16,
                              backgroundImage: (selectedImage != null)
                                  ? FileImage(selectedImage!)
                                  : (NetworkImage(Constants.PLACEHOLDER_PFP)
                                      as ImageProvider),
                            ),
                          ),
                        ),
                      ),
                // Email field
                Container(
                  margin: const EdgeInsets.only(bottom: 20, top: 20),
                  width: 300,
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Enter Email Address",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      formValidation();
                    },
                    validator: (value) {
                      RegExp finalRegExp = Constants.EMAIL_VALIDATION_REGEX;
                      if (value!.isEmpty) {
                        return 'Please enter Email Address';
                      } else if (!finalRegExp.hasMatch(
                              value) /*&&
                          isLoginPage == false*/
                          ) {
                        return 'Enter a valid email address!';
                      }
                      return null;
                    },
                  ),
                ),
                //Password field
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 300,
                  child: TextFormField(
                    controller: password,
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      formValidation();
                    },
                    validator: (value) {
                      RegExp finalRegExp = Constants.PASSWORD_VALIDATION_REGEX;
                      if (value!.isEmpty) {
                        return "Enter Password";
                      } else if (!finalRegExp.hasMatch(value) &&
                          isLoginPage == false) {
                        return 'Enter a valid Password!';
                      }
                      return null;
                    },
                  ),
                ),
                //ReEnter Password field
                Visibility(
                  visible: !isLoginPage,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 300,
                    child: TextFormField(
                      controller: rePassword,
                      decoration: const InputDecoration(
                        labelText: "Enter Password Again",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        formValidation();
                      },
                      validator: (value) {
                        if (value != password.text || value!.isEmpty) {
                          return "Enter same password.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                // Login Signup Container
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  width: 300,
                  height: 50,
                  child: Row(
                    children: [
                      //sigup button
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.zero,
                                    left: Radius.circular(50)),
                              ),
                            ),
                            icon: const Icon(Icons.signpost_outlined),
                            label: Text(
                              "SignUp",
                              style: TextStyle(
                                fontWeight: (isLoginPage == true)
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                fontSize: (isLoginPage == true) ? null : 20,
                              ),
                            ),
                            onPressed: () async {
                              if (isLoginPage == true) {
                                setState(() {
                                  isLoginPage = false;
                                  password.clear();
                                  rePassword.clear();
                                });
                              } else {
                                //it is signup page
                                //save info function
                                if (_formKey.currentState!.validate()) {
                                  c.saveInfo(email.text, password.text);
                                } else {
                                  Get.snackbar(
                                      "Error", "Please enter valid details.");
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        width: 2,
                        thickness: 0,
                      ),
                      //Login button
                      Expanded(
                        child: SizedBox(
                          height: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.circular(50)),
                              ),
                            ),
                            icon: const Icon(Icons.login_outlined),
                            label: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: (isLoginPage == true)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: (isLoginPage == true) ? 20 : null,
                              ),
                            ),
                            onPressed: () {
                              if (isLoginPage == false) {
                                setState(() {
                                  isLoginPage = true;
                                  password.clear();
                                  rePassword.clear();
                                });
                              } else {
                                //it is login page
                                //check info function
                                if (_formKey.currentState!.validate()) {
                                  c.loginInfo(
                                      email.text, password.text, _authService);
                                } else {
                                  Get.snackbar("Error",
                                      "Username or Password are incorrect!");
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Google sign in button
                ElevatedButton(
                  onPressed: () {
                    c.handleGoogleSignIn();
                  },
                  child: const Text("Login With Google"),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
