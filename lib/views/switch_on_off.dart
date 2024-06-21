import 'dart:async';
import 'package:dio/dio.dart';
import '../controllers/storage.dart';
import '../widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';

class SwitchOnOff extends StatefulWidget {
  const SwitchOnOff(
      {required this.IP,
        required this.switchPassKey,
        required this.switchID,
        super.key});
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
    // TODO: implement initState
    _timer = Timer(const Duration(seconds: 20), () {
      _navigateToNextPage();
    });
    super.initState();
    updateSwitch();
  }

  void _navigateToNextPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyNavigationBar(),
      ),
          (route) => false, //if you want to disable back feature set to false
    );
  }

  void _buttonPressed() {
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 20), () {
      _navigateToNextPage();
    });
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
    _buttonPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: updateSwitch,
        child: const Icon(Icons.refresh_rounded),
      ),
      appBar: PreferredSize(
        child: CustomAppBar(heading: ""),
        preferredSize: const Size.fromHeight(60),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: backGroundColour),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "The status of the Switch is ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    switchStatus.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  color: whiteColour, borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async {
                        _buttonPressed();
                        try {
                          String res = await ApiConnect.hitApiGet(
                              "${widget.IP}/Switchstatus");
                          if (res == "OK CLOSE") {
                            ApiConnect.hitApiPost("${widget.IP}/getSwitchcmd", {
                              "Lock_id": widget.switchID,
                              "lock_passkey": widget.switchPassKey,
                              "lock_cmd": "ON"
                            });
                            setState(() {
                              switchOff = false;
                              switchStatus = "On";
                              //storage.updateSwitchStatus(widget.switchID, switchOff);
                            });

                          } else if (res == "OK OPEN") {
                            ApiConnect.hitApiPost("${widget.IP}/getSwitchcmd", {
                              "Lock_id": widget.switchID,
                              "lock_passkey": widget.switchPassKey,
                              "lock_cmd": "OFF"
                            });
                            setState(() {
                              switchStatus = "Off";
                              switchOff = true;
                              //storage.updateSwitchStatus(widget.switchID, switchOff);
                            });
                          } else {}
                        } on DioException {
                          final scaffold = ScaffoldMessenger.of(context);
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text("Unable to perform. Try Again."),
                            ),
                          );
                        } catch (e) {
                          print(e.toString());
                        } finally {
                          _buttonPressed();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              // spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 100,
                          child: Icon(
                            Icons.power_settings_new,
                            size: 60,
                            color: switchOff
                                ? redButtonColour
                                : greenButtonColour,
                          ),
                          backgroundColor: switchOff ? redColour : greenColour,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}