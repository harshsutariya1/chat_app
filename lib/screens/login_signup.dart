// ignore_for_file: avoid_print

import 'dart:io';

import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/services/storage_services.dart';
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
  final c = Get.find<LoginSignupFunctions>();
  late AuthService _authService;
  late MediaServices _mediaServices;
  late StorageService _storageServices;
  late DatabaseService _databaseServices;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? selectedImage;
  bool isLoginPage = false;
  bool formvalidation = false;
  bool isLoadingLogin = false;
  bool isLoadingSignup = false;
  bool isLoadingGoogle = false;

  @override
  void initState() {
    // _authService = Get.find<AuthService>();
    _authService = GetIt.instance.get<AuthService>();
    _mediaServices = GetIt.instance.get<MediaServices>();
    _storageServices = GetIt.instance.get<StorageService>();
    _databaseServices = GetIt.instance.get<DatabaseService>();
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
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        height: screenSize.height,
        color: const Color.fromARGB(147, 190, 230, 215),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (isLoginPage)
                    ? SizedBox(
                        height: screenSize.height * 0.4,
                        width: screenSize.width,
                        child: Image.asset("assets/Images/171_bgremoved.png"),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 40),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Let's Get going...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          //Image Picker
                          GestureDetector(
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
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              // decoration: BoxDecoration(border: Border.all()),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius:
                                    MediaQuery.of(context).size.width * 0.17,
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.16,
                                  backgroundImage: (selectedImage != null)
                                      ? FileImage(selectedImage!)
                                      : (NetworkImage(Constants.PLACEHOLDER_PFP)
                                          as ImageProvider),
                                ),
                              ),
                            ),
                          ),
                          //Name field
                          Container(
                            margin: const EdgeInsets.only(bottom: 20, top: 20),
                            width: screenSize.width * 0.70,
                            child: TextFormField(
                              controller: name,
                              decoration: const InputDecoration(
                                labelText: "Enter Name",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                formValidation();
                              },
                              validator: (value) {
                                RegExp nameRegExp =
                                    Constants.NAME_VALIDATION_REGEX;
                                if (value!.isEmpty) {
                                  return 'Please enter Name';
                                } else if (!nameRegExp.hasMatch(value)) {
                                  return 'Enter valid name, i.e. John Smith';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                // Email field
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20, /* top: 20*/
                  ),
                  width: screenSize.width * 0.70,
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
                      RegExp emailRegExp = Constants.EMAIL_VALIDATION_REGEX;
                      if (value!.isEmpty) {
                        return 'Please enter Email Address';
                      } else if (!emailRegExp.hasMatch(
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
                  width: screenSize.width * 0.70,
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
                      RegExp passwordRegExp =
                          Constants.PASSWORD_VALIDATION_REGEX;
                      if (value!.isEmpty) {
                        return "Enter Password";
                      } else if (!passwordRegExp.hasMatch(value) &&
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
                    width: screenSize.width * 0.70,
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
                  width: screenSize.width * 0.70,
                  height: screenSize.height * 0.07,
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
                            label: (isLoadingSignup)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    "SignUp",
                                    style: TextStyle(
                                      fontWeight: (isLoginPage == true)
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                      fontSize:
                                          (isLoginPage == true) ? null : 20,
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
                                //it is signup page //save info function
                                if ((_formKey.currentState!.validate()) &&
                                    (selectedImage != null)) {
                                  setState(() {
                                    isLoadingSignup = true;
                                  });

                                  try {
                                    bool result = await c.saveInfo(email.text,
                                        password.text, _authService);
                                    if (result) {
                                      String? pfpicUrl = await _storageServices
                                          .uploadUserPfpic(
                                        file: selectedImage!,
                                        uid: _authService.user!.uid,
                                      );
                                      print(
                                          "--------------Download Url: $pfpicUrl :--------------");
                                      if (pfpicUrl != null) {
                                        await _databaseServices
                                            .createUserProfile(
                                          userProfile: UserProfile(
                                              uid: _authService.user!.uid,
                                              name: name.text,
                                              pfpURL: pfpicUrl),
                                        );
                                      } else {
                                        throw Exception(
                                            "Unable to Upload user profile picture");
                                      }
                                    }
                                    setState(() {
                                      isLoadingSignup = result;
                                    });
                                  } catch (e) {
                                    print("Error aii lya: $e");
                                  }
                                } else {
                                  Get.snackbar(
                                      "Error", "Unable to Register User!.");
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
                            label: (isLoadingLogin)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: (isLoginPage == true)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize:
                                          (isLoginPage == true) ? 20 : null,
                                    ),
                                  ),
                            onPressed: () async {
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
                                  setState(() {
                                    isLoadingLogin = true;
                                  });

                                  bool result = await c.loginInfo(
                                      email.text, password.text, _authService);

                                  setState(() {
                                    isLoadingLogin = result;
                                  });
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
                  onPressed: () async {
                    setState(() {
                      isLoadingGoogle = true;
                    });

                    bool result = await c.handleGoogleSignIn(
                      _storageServices,
                      _databaseServices,
                      _authService,
                    );

                    setState(() {
                      isLoadingGoogle = result;
                    });
                  },
                  child: (isLoadingGoogle)
                      ? SizedBox(
                          width: screenSize.width * 0.3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const Text(
                          "Login With Google",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
