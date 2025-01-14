import 'package:bbt_switch/views/grouping_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../controllers/permission.dart';
import '../views/contacts.dart';
import '../views/home_page.dart';
import '../views/router_page.dart';
import '../views/settings.dart';
import '../views/switches_page.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});
  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    requestPermission(Permission.camera);
    requestPermission(Permission.contacts);
    requestPermission(Permission.location);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          const HomePage(),
          const ContactsPage(),
          SwitchPage(),
          RouterPage(),
          GroupingPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/home.png",
              height: 35,
            ),
            label: ('Home'),
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/user.png",
              height: 35,
            ),
            label: ('Users'),
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/switch.png", height: 45),
            label: ('Switches'),
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/wifi-router.png",
              height: 40,
            ),
            label: ('Router'),
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/group_icon.png",
              height: 45,
            ),
            label: ('Groups'),
            backgroundColor: backGroundColour,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/settings.png",
              height: 35,
            ),
            label: ('Settings'),
            backgroundColor: backGroundColour,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        iconSize: 40,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
