import 'package:chat_app/constants/widgets_functions/login_signup_functions.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_services.dart';
import 'package:chat_app/services/media_services.dart';
import 'package:chat_app/services/storage_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase app is initialized!');
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaServices>(MediaServices());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  Get.put<LoginSignupFunctions>(LoginSignupFunctions());
}

String generateChatId({required String uid1, required String uid2}) {
  List uids = [uid1, uid2];
  uids.sort();
  String chatId = uids.fold("", (id, uid) => "$id$uid");
  return chatId;
}
