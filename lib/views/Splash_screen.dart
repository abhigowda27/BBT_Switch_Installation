import 'dart:async';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../bottom_nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundColorAnimation1;
  late Animation<Color?> _backgroundColorAnimation2;
  late Animation<Color?> _backgroundColorAnimation3;
  bool _logoVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _backgroundColorAnimation1 = ColorTween(
      begin: const Color(0xff2902d096a),
      end: const Color(0xffee6e43bd),
    ).animate(_controller);

    _backgroundColorAnimation2 = ColorTween(
      begin: const Color(0xffee6e43bd),
      end: const Color(0xff2902d096a),
    ).animate(_controller);

    _backgroundColorAnimation3 = ColorTween(
      begin: const Color(0xff2902d096a),
      end: const Color(0xffee6e43bd),
    ).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _logoVisible = true;
        });

        Timer(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyNavigationBar()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.height * 0.15;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _backgroundColorAnimation1.value ?? const Color(0xff2902d096a),
                  _backgroundColorAnimation2.value ?? const Color(0xffee6e43bd),
                  _backgroundColorAnimation3.value ?? const Color(0xff2902d096a),
                ],
                stops: const [0, 0.5, 1],
                begin: const AlignmentDirectional(-1, -1),
                end: const AlignmentDirectional(1, 1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                AnimatedOpacity(
                  opacity: _logoVisible ? 1.0 : 0.0,
                  duration: const Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 100,
                          color: backGroundColour,
                          offset: const Offset(0, 2),
                        )
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
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'BelBird Technologies',
                    style: TextStyle(
                      color: whiteColour,
                      fontSize: MediaQuery.of(context).size.height * .04,
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
                        'Transforming Technologies for Tomorrow',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: MediaQuery.of(context).size.height * .02,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 180),
              ],
            ),
          );
        },
      ),
    );
  }
}
