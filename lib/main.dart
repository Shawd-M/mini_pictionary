import 'package:flutter/material.dart';
import 'package:my_pic/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'View/login_page.dart';

const mainColor = Color(0xFF6F35A5);
const mainLightColor = Color(0xFFF1E6FF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen()
    ));
}