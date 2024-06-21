
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/media_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase app is initialized!');
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaServices>(MediaServices());
  // Get.put<AuthService>(AuthService());
}