import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bbt_switch/widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/permission.dart';
import '../controllers/storage.dart';
import '../models/router_model.dart';
import '../views/qr_pin.dart';
import '../views/sharePage.dart';

class RouterCard extends StatefulWidget {
  final RouterDetails routerDetails;
  RouterCard({
    required this.routerDetails,
    super.key,
  });

  @override
  State<RouterCard> createState() => _RouterCardState();
}

class _RouterCardState extends State<RouterCard> {
  bool hide = true;
  StorageController _storageController = StorageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                        widget.routerDetails.switchID,
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
                        widget.routerDetails.switchName,
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
                      "Router Name : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        widget.routerDetails.name,
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
                                widget.routerDetails.switchPasskey.length,
                                (index) => "*").join()
                            : widget.routerDetails.switchPasskey,
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
                      "Router Password: ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: Text(
                        hide
                            ? List.generate(
                                widget.routerDetails.password.length,
                                (index) => "*").join()
                            : widget.routerDetails.password,
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
                      // SizedBox(
                      //   width: 10,
                      // ),
                      IconButton(
                          tooltip: "Delete Router",
                          onPressed: () {
                            String localConnectStatus = _connectionStatus;
                            localConnectStatus = localConnectStatus.substring(
                                1, localConnectStatus.length - 1);
                            if (!_connectionStatus
                                .contains(widget.routerDetails.name)) {
                              showToast(context,
                                  "You should be connected to ${widget.routerDetails.name} to delete the switch");
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (cont) {
                                return AlertDialog(
                                  title: const Text('Delete Router'),
                                  content:
                                      const Text('This will delete the Router'),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'CANCEL',
                                        style: TextStyle(color: appBarColour),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        _storageController.deleteOneRouter(
                                            widget.routerDetails);
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
                                      child: Text(
                                        'OK',
                                        style: TextStyle(color: appBarColour),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete_outline,
                              color: backGroundColour)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          tooltip: "Show Details",
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
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(color: appBarColour),
                                        ),
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
                                                            routerDetails: widget
                                                                .routerDetails)),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(color: appBarColour),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.share_rounded,
                              color: backGroundColour))
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
