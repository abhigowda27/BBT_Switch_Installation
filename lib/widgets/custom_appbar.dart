import 'package:flutter/material.dart';
import '../constants.dart';

class CustomAppBar extends StatelessWidget {
    const CustomAppBar({required this.heading, super.key});
  final String heading;
  // bool? isBack = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        iconTheme: IconThemeData(color: appBarColour),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: width*0.07,
          ),
        ),
        backgroundColor: backGroundColour,
        automaticallyImplyLeading: false,
        title: Text(
          heading,
          style: TextStyle(
              color: appBarColour, fontSize: width*0.07, fontWeight: FontWeight.bold),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
