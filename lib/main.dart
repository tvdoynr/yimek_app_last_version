import 'package:flutter/material.dart';
import 'package:yimek_app_lastversion/screens/comment_page.dart';
import 'package:yimek_app_lastversion/screens/home_page.dart';
import 'package:yimek_app_lastversion/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "title",
      home: LoginPage(),
    );
  }
}

