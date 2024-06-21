import '../constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.height * 0.15; // Reduced the radius to minimize the logo size
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2902d096a), Color(0xffee6e43bd), Color(0xff2902d096a)], // New gradient colors
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(-1, -1),
            end: AlignmentDirectional(1, 1),
          ),
        ),
        child: Container(
          width: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x00FFFFFF), Colors.white],
              stops: [0, 1],
              begin: AlignmentDirectional(-1, 0),
              end: AlignmentDirectional(1, 1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
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
              const SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'BelBird Technologies',
                  style: TextStyle(
                    color: whiteColour,
                    fontSize: MediaQuery.of(context).size.height * .04,
                    fontWeight: FontWeight.bold,
                  ),
                    textAlign: TextAlign.center
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
        ),
      ),
    );
  }
}

