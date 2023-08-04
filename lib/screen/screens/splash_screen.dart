import 'package:flutter/material.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5)).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'MUNA GLOBAL',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                wordSpacing: 10,
                letterSpacing: -2,
              ),
            ),
            Text(
              'Let\'s get it done',
              style: TextStyle(
                fontSize: 25,
                color: Colors.blue,
                wordSpacing: 5,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
