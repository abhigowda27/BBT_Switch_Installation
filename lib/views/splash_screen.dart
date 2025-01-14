import 'dart:async';

import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final double radius = height * 0.2;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff4a85a8).withOpacity(0.5),
              const Color(0xff09a2f3),
              const Color(0xff4a85a8).withOpacity(0.3),
            ],
            stops: const [0, 0.5, 1],
            begin: const AlignmentDirectional(-1, -1),
            end: const AlignmentDirectional(1, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 100,
                        color: backGroundColour,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(width: 10, color: backGroundColourDark),
                  ),
                  child: Container(
                    height: radius,
                    width: radius,
                    decoration: BoxDecoration(
                      color: whiteColour,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Image.asset(
                        "assets/images/BBT_Logo_2.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'BelBird Technologies',
                    style: TextStyle(
                      color: whiteColour,
                      fontSize: height * .04,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    children: [
                      Text(
                        'Transforming Technologies for tomorrow',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: height * .02,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
