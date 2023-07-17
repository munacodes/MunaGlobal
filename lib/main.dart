import 'package:flutter/material.dart';
import 'package:muna_global/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muna_global/home.dart';
import 'package:muna_global/screens/screens_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Muna Global',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
