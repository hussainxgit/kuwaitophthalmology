import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '/views/auth/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Colors.blueAccent])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: [
                  Material(
                      elevation: 8.0,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        child:
                            Image.asset('graphics/iris_logo_and_wordmark.png'),
                        radius: 50.0,
                      )),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text(
                    "Kuwait Ophthalmology Board",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        color: color),
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 60,
                width: 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white,
                ),
                child: TextButton(
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8185E2),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => const LoginView());
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
