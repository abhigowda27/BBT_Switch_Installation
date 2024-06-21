import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../controllers/storage.dart';
import '../models/router_model.dart';
import '../widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../controllers/permission.dart';

class AutoSwitch extends StatefulWidget {
  final RouterDetails switchDetails;
  AutoSwitch({
    required this.switchDetails,
    super.key,
  });

  @override
  State<AutoSwitch> createState() => _SwitchesCardState();
}

class _SwitchesCardState extends State<AutoSwitch> {
  StorageController _storageController = StorageController();

  String switchStatus = "Off";
  bool switchOff = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
    updateSwitch();

    connectivitySubscription = _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  void updateSwitch() async {
    String res = await ApiConnect.hitApiGet("${widget.switchDetails.iPAddress}/Switchstatus");
    setState(() {
      if (res == "OK CLOSE") {
        switchOff = true;
        switchStatus = "Off";
      } else {
        switchOff = false;
        switchStatus = "On";
      }
    });
  }
  // Future<void> _saveMainSwitchState(bool value) async {
  //   setState(() {
  //     isSwitchOn = value;
  //   });
  //   await _storageController.saveSwitchState(value);
  // }

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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(5, 5),
              ),
            ],
            color: backGroundColour,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the ends
            children: [
              Flexible(
                child: Text(
                  widget.switchDetails.name + "_" + widget.switchDetails.switchName,
                  style: TextStyle(
                    fontSize: 20,
                    color: whiteColour,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Transform.scale(
                scale: 1,
                child: Switch(
                  onChanged: (value) async {
                    String localConnectStatus = _connectionStatus;
                    localConnectStatus = localConnectStatus.substring(
                        1, localConnectStatus.length - 1);
                    if (localConnectStatus != widget.switchDetails.name) {
                      showToast(context,
                          "You should be connected to ${widget.switchDetails.name} to refresh the switch settings");
                      return;
                    }
                    try{
                    if (value) {
                      ApiConnect.hitApiPost(
                          "${widget.switchDetails.iPAddress}/getSwitchcmd", {
                        "Lock_id": widget.switchDetails.switchID,
                        "lock_passkey": widget.switchDetails.switchPasskey,
                        "lock_cmd": "ON"
                      });
                      setState(() {
                        switchOff = false;
                        switchStatus = "On";
                      });

                    } else if(!value){
                      ApiConnect.hitApiPost(
                          "${widget.switchDetails.iPAddress}/getSwitchcmd", {
                        "Lock_id": widget.switchDetails.switchID,
                        "lock_passkey": widget.switchDetails.switchPasskey,
                        "lock_cmd": "OFF"
                      });
                      setState(() {
                        switchStatus = "Off";
                        switchOff = true;
                      });
                      await _storageController.saveMainSwitchState(value);
                      await _storageController.saveGroupSwitchState(value);
                    } else{}
                    }
                    on DioException {
                      final scaffold = ScaffoldMessenger.of(context);
                      scaffold.showSnackBar(const SnackBar(
                      content: Text("Unable to perform. Try Again."),),);
                    } catch (e) {
                      print(e.toString());
                    }
                    //await _storageController.updateSwitchAutoStatus(widget.switchDetails.switchName, value);
                  },
                  value: !switchOff,
                  activeColor: greenButtonColour,
                  activeTrackColor: greenColour,
                  inactiveThumbColor: redButtonColour,
                  inactiveTrackColor: redColour,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
