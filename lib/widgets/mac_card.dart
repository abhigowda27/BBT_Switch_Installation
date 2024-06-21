import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/permission.dart';
import '../widgets/toast.dart';
import 'package:flutter/services.dart';
import '../controllers/storage.dart';
import '../models/mac_model.dart';
import 'package:flutter/material.dart';
import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';

class MacCard extends StatefulWidget {
  final MacsDetails macsDetails;

  MacCard({
    required this.macsDetails,
    super.key,
  });

  @override
  State<MacCard> createState() => _MacCardState();
}

class _MacCardState extends State<MacCard> {
  StorageController _storageController = StorageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSwitched = widget.macsDetails.isPresentInESP;
  }
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      await requestPermission(Permission.nearbyWifiDevices);
      // await requestPermission(Permission.locationWhenInUse);
    } catch (e) {
      print(e.toString());
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi Name', error: e);
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (!kIsWeb && Platform.isIOS) {
        // ignore: deprecated_member_use
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          // ignore: deprecated_member_use
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      //developer.log('Failed to get Wifi gateway address', error: e);
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    setState(() {
      _connectionStatus = wifiName!.toString();
      // 'Wifi BSSID: $wifiBSSID\n'
      // 'Wifi IPv4: $wifiIPv4\n'
      // 'Wifi IPv6: $wifiIPv6\n'
      // 'Wifi Broadcast: $wifiBroadcast\n'
      // 'Wifi Gateway: $wifiGatewayIP\n'
      // 'Wifi Submask: $wifiSubmask\n';
    });
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          // height: 150,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5), // changes position of shadow
            ),
          ], color: whiteColour, borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Switch ID : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        widget.macsDetails.switchDetails.switchSSID,
                        style: TextStyle(
                            fontSize: 20,
                            color: blackColour,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Mac ID : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        widget.macsDetails.id,
                        style: TextStyle(
                            fontSize: 20,
                            color: blackColour,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Mac Name : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        widget.macsDetails.name,
                        style: TextStyle(
                            fontSize: 20,
                            color: blackColour,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              new ClipboardData(text: widget.macsDetails.id));
                          showToast(context, "Mac Id copied");
                        },
                        icon: Icon(Icons.copy)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        tooltip: "Delete Switch",
                        onPressed: () {
                          String localConnectStatus = _connectionStatus;
                          localConnectStatus = localConnectStatus.substring(1, localConnectStatus.length - 1);
                          if (localConnectStatus != widget.macsDetails.switchDetails.switchSSID) {
                            showToast(context,
                                "You should be connected to ${widget.macsDetails.switchDetails.switchSSID} to refresh the switch settings");
                            return;
                          }
                          showDialog(
                              context: context,
                              builder: (cont) {
                                final formKey = GlobalKey<FormState>();
                                TextEditingController _pinController =
                                TextEditingController();
                                return Form(
                                  key: formKey,
                                  child: AlertDialog(
                                    title: Text(widget.macsDetails.switchDetails.switchSSID),
                                    content: const Text(
                                        'Enter the switch pin to proceed'),
                                    actions: [
                                      Column(
                                        children: [
                                          TextFormField(
                                            maxLength: 4,
                                            controller: _pinController,
                                            validator: (value) {
                                              if (value!.length <= 3) {
                                                return "Switch Pin cannot be less than 4 letters";
                                              }
                                              if (_pinController.text !=
                                                  widget.macsDetails.switchDetails
                                                      .privatePin) {
                                                return "Pin does not match";
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                // borderSide: BorderSide(width: 40),
                                              ),
                                              labelText: "Enter Old Pin",
                                              labelStyle: const TextStyle(
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('CANCEL'),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              OutlinedButton(
                                                onPressed: () async{
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    if (_pinController.text == widget.macsDetails.switchDetails.privatePin) {
                                                      _storageController.deleteOneMacs(widget.macsDetails);
                                                      await ApiConnect.hitApiGet(
                                                        "$routerIP/",
                                                      );
                                                      Navigator.pop(context);

                                                      await ApiConnect.hitApiPost(
                                                          "$routerIP/deletemac", {
                                                        "MacID": widget.macsDetails.id.toLowerCase(),
                                                      });
                                                    }
                                                    else {
                                                      Navigator.pop(context);
                                                      showToast(context,
                                                          "Pin do not match");
                                                    }
                                                  }
                                                },
                                                child: const Text('Confirm'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        icon: const Icon(Icons.delete_outline_rounded)),
                    const SizedBox(
                      width: 10,
                    ),
                    Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: (value) async {
                            setState(() {
                              isSwitched = value;
                            });
                            // return;
                            print(value);
                            if (value) {
                              // await ApiConnect.hitApiGet(
                              //   "$routerIP/",
                              // );

                              // Navigator.pop(context);

                              var res = await ApiConnect.hitApiPost(
                                  "$routerIP/MacOnOff", {
                                "MacCheck": "ON",
                              });
                              print(res);
                            } else {
                              var res = await ApiConnect.hitApiPost(
                                  "$routerIP/MacOnOff", {
                                "MacCheck": "OFF",
                              });
                              print(res);
                            }
                            MacsDetails macD = MacsDetails(
                                id: widget.macsDetails.id,
                                switchDetails: widget.macsDetails.switchDetails,
                                name: widget.macsDetails.name,
                                isPresentInESP: isSwitched);
                            _storageController.updateMacStatus(macD);

                            // Navigator.pop(context);
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    MyNavigationBar(),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                          value: isSwitched,
                          activeColor: appBarColour,
                          activeTrackColor: backGroundColour,
                          inactiveThumbColor: blackColour,
                          inactiveTrackColor: whiteColour,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
