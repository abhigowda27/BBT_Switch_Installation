import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/permission.dart';
import '../controllers/storage.dart';
import '../models/switch_model.dart';
import '../views/add_router.dart';
import '../views/qr_pin.dart';
import '../views/sharePage.dart';
import '../views/update_switch_name.dart';
import 'toast.dart';

class SwitchesCard extends StatefulWidget {
  final SwitchDetails switchesDetails;
  SwitchesCard({
    required this.switchesDetails,
    super.key,
  });

  @override
  State<SwitchesCard> createState() => _SwitchesCardState();
}

class _SwitchesCardState extends State<SwitchesCard> {
  StorageController _storageController = StorageController();
  bool hide = true;

  ConnectivityResult _connectionStatusS = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();

    connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    for (var result in results) {
      _initNetworkInfo(); // Process each result as needed
    }
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
      developer.log('Failed to get Wifi Name', error: e);
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
      developer.log('Failed to get Wifi BSSID', error: e);
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv4', error: e);
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      if (!Platform.isWindows) {
        wifiIPv6 = await _networkInfo.getWifiIPv6();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi IPv6', error: e);
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      if (!Platform.isWindows) {
        wifiSubmask = await _networkInfo.getWifiSubmask();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi submask address', error: e);
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      if (!Platform.isWindows) {
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi broadcast', error: e);
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      if (!Platform.isWindows) {
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      }
    } on PlatformException catch (e) {
      developer.log('Failed to get Wifi gateway address', error: e);
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
              offset: const Offset(5, 5),
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
                        widget.switchesDetails.switchId,
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
                      "Switch Name : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        widget.switchesDetails.switchSSID,
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
                      "Switch PassKey : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        hide
                            ? List.generate(
                                widget.switchesDetails.switchPassKey!.length,
                                (index) => "*").join()
                            : widget.switchesDetails.switchPassKey!,
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
                      "Switch Password: ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        hide
                            ? List.generate(
                                widget.switchesDetails.switchPassword.length,
                                (index) => "*").join()
                            : widget.switchesDetails.switchPassword,
                        style: TextStyle(
                            fontSize: 20,
                            color: blackColour,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: appBarColour,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          tooltip: "Delete Switch",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (cont) {
                                  final formKey = GlobalKey<FormState>();
                                  TextEditingController pinController =
                                      TextEditingController();

                                  return Form(
                                    key: formKey,
                                    child: AlertDialog(
                                      title: Text(
                                          widget.switchesDetails.switchSSID),
                                      content: const Text(
                                          'Enter the switch pin to proceed'),
                                      actions: [
                                        Column(
                                          children: [
                                            TextFormField(
                                              maxLength: 4,
                                              controller: pinController,
                                              validator: (value) {
                                                if (value!.length <= 3) {
                                                  return "Switch Pin cannot be less than 4 letters";
                                                }
                                                if (pinController.text !=
                                                    widget.switchesDetails
                                                        .privatePin) {
                                                  return "Pin does not match";
                                                }
                                                return null;
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
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      if (pinController.text ==
                                                          widget.switchesDetails
                                                              .privatePin) {
                                                        _storageController
                                                            .deleteOneSwitch(widget
                                                                .switchesDetails);
                                                        Navigator
                                                            .pushAndRemoveUntil<
                                                                dynamic>(
                                                          context,
                                                          MaterialPageRoute<
                                                              dynamic>(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                const MyNavigationBar(),
                                                          ),
                                                          (route) =>
                                                              false, //if you want to disable back feature set to false
                                                        );
                                                      } else {
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
                                });
                          },
                          icon: Icon(Icons.delete_outline_rounded,
                              color: backGroundColour)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          tooltip: "Refresh Switch",
                          onPressed: () {
                            String localConnectStatus = _connectionStatus;
                            localConnectStatus = localConnectStatus.substring(
                                1, localConnectStatus.length - 1);
                            if (localConnectStatus !=
                                widget.switchesDetails.switchSSID) {
                              showToast(context,
                                  "You should be connected to ${widget.switchesDetails.switchSSID} to refresh the switch");
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
                                      title: const Text('BBT Switch'),
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
                                                    widget.switchesDetails
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
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      if (_pinController.text ==
                                                          widget.switchesDetails
                                                              .privatePin) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    UpdateSwitchInstallationPage(
                                                                        switchDetails:
                                                                            widget.switchesDetails)));
                                                      } else {
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
                                });
                          },
                          icon: Icon(Icons.refresh_rounded,
                              color: backGroundColour)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          tooltip: "Share",
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide
                              ? Icon(Icons.remove_red_eye,
                                  color: backGroundColour)
                              : Icon(CupertinoIcons.eye_slash_fill,
                                  color: backGroundColour)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (cont) {
                                  return AlertDialog(
                                    title: const Text('BBT Switch'),
                                    content: const Text(
                                        'Do you want to share the Switch'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          final qrPin = await _storageController
                                              .getQrPin();
                                          PinDialog pinDialog =
                                              PinDialog(context);
                                          pinDialog.showPinDialog(
                                            isFirstTime: qrPin == null,
                                            onSuccess: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShareQRPage(
                                                            switchDetails: widget
                                                                .switchesDetails)),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.share_rounded,
                              color: backGroundColour)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          tooltip: "Add Router",
                          onPressed: () async {
                            String localConnectStatus = _connectionStatus;
                            localConnectStatus = localConnectStatus.substring(
                                1, localConnectStatus.length - 1);
                            if (localConnectStatus !=
                                widget.switchesDetails.switchSSID) {
                              showToast(context,
                                  "You should be connected to ${widget.switchesDetails.switchSSID} to add the Router");
                              return;
                            }
                            // bool exists =
                            //     await _storageController.isSwitchIDExists(
                            //         widget.switchesDetails.switchId);
                            // if (exists) {
                            //   final scaffold = ScaffoldMessenger.of(context);
                            //   scaffold.showSnackBar(
                            //     const SnackBar(
                            //       content: Text(
                            //           "Router is already Exist for this switch, Delete the previous router to install the switch with new router"),
                            //     ),
                            //   );
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => MyNavigationBar()));
                            //   return;
                            // }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NewRouterInstallationPage(
                                          switchId:
                                              widget.switchesDetails.switchId,
                                          switchSSID:
                                              widget.switchesDetails.switchSSID,
                                          switchPassKey: widget
                                              .switchesDetails.switchPassKey!,
                                          isFromSwitch: true,
                                        )));
                          },
                          icon: Transform.rotate(
                            angle: -90 * 3.1415926535897932 / 180,
                            child: SvgPicture.asset(
                              "assets/images/wifi.svg",
                              color: backGroundColour,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
