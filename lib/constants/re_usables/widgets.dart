import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget homeScreenButton({required String buttonName, required String goto}) {
  return InkWell(
    onTap: () {
      print("$buttonName button pressed");
      Get.toNamed(goto);
    },
    child: Container(
      alignment: Alignment.center,
      height: 50,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 235, 235, 235),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 117, 189, 245),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(5, 5))
        ],
      ),
      child: Text(
        buttonName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.blue,
        ),
      ),
    ),
  );
}
