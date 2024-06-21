// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  static const Color backgroundColor = Color.fromARGB(255, 173, 212, 233);
  
  static RegExp EMAIL_VALIDATION_REGEX =
      RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  static RegExp PASSWORD_VALIDATION_REGEX =
      RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

  static RegExp NAME_VALIDATION_REGEX = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");

  static String PLACEHOLDER_PFP =
      "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";
}
