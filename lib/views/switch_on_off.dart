import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../controllers/storage.dart';
import '../widgets/custom_appbar.dart';

class SwitchOnOff extends StatefulWidget {
  const SwitchOnOff({
    required this.IP,
    required this.switchPassKey,
    required this.switchID,
    super.key,
  });

  final String IP;
  final String switchID;
  final String switchPassKey;

  @override
  State<SwitchOnOff> createState() => _SwitchOnOffState();
}

class _SwitchOnOffState extends State<SwitchOnOff> {
  StorageController storage = StorageController();
  String switchStatus = "Off";
  bool switchOff = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    updateSwitch();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 15), _navigateToNextPage);
  }

  void _resetTimer() {
    _timer.cancel();
    _startTimer();
  }

  void _navigateToNextPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyNavigationBar(),
      ),
      (route) => false, // Disable back feature
    );
  }

  void updateSwitch() async {
    String res = await ApiConnect.hitApiGet("${widget.IP}/Switchstatus");
    setState(() {
      if (res == "OK CLOSE") {
        switchOff = true;
        switchStatus = "Off";
      } else {
        switchOff = false;
        switchStatus = "On";
      }
    });
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColour,
        onPressed: updateSwitch,
        child: const Icon(Icons.refresh_rounded),
      ),
      appBar: PreferredSize(
        child: CustomAppBar(heading: ""),
        preferredSize: const Size.fromHeight(60),
      ),
      body: GestureDetector(
        onTap: _resetTimer,
        child: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: backGroundColour),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "The status of the Switch is ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      switchStatus.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: whiteColour,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _resetTimer();
                        try {
                          String res = await ApiConnect.hitApiGet(
                              "${widget.IP}/Switchstatus");
                          if (res == "OK CLOSE") {
                            await ApiConnect.hitApiPost(
                                "${widget.IP}/getSwitchcmd", {
                              "Lock_id": widget.switchID,
                              "lock_passkey": widget.switchPassKey,
                              "lock_cmd": "ON",
                            });
                            setState(() {
                              switchOff = false;
                              switchStatus = "On";
                            });
                          } else if (res == "OK OPEN") {
                            await ApiConnect.hitApiPost(
                                "${widget.IP}/getSwitchcmd", {
                              "Lock_id": widget.switchID,
                              "lock_passkey": widget.switchPassKey,
                              "lock_cmd": "OFF",
                            });
                            setState(() {
                              switchStatus = "Off";
                              switchOff = true;
                            });
                          }
                        } on DioException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Unable to perform. Try Again."),
                            ),
                          );
                        } catch (e) {
                          print(e.toString());
                        } finally {
                          _resetTimer();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 7,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: switchOff ? redColour : greenColour,
                          child: Icon(
                            Icons.power_settings_new,
                            size: 60,
                            color:
                                switchOff ? redButtonColour : greenButtonColour,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
