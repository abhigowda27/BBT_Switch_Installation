import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bbt_switch/models/router_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../controllers/permission.dart';
import '../controllers/storage.dart';
import '../widgets/auto_switches_card.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/toast.dart';

class AutoSwitchPage extends StatefulWidget {
  const AutoSwitchPage({super.key});

  @override
  State<AutoSwitchPage> createState() => _AutoSwitchPageState();
}

class _AutoSwitchPageState extends State<AutoSwitchPage> {
  final StorageController _storageController = StorageController();
  late bool isSwitchOn = false;

  Future<List<RouterDetails>> fetchRouters() async {
    return _storageController.readRouters();
  }

  // Future<List<SwitchDetails>> fetchSwitches() async {
  //   return _storageController.readSwitches();
  // }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ConnectivityResult _connectionStatusS = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 20), _navigateToNextPage);
    _initNetworkInfo();
    _loadSwitchState();
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

  Future<void> _loadSwitchState() async {
    bool state = await _storageController.loadMainSwitchState();
    setState(() {
      isSwitchOn = state;
    });
  }

  Future<void> _saveMainSwitchState(bool value) async {
    setState(() {
      isSwitchOn = value;
    });
    await _storageController.saveMainSwitchState(value);
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

  void _navigateToNextPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const MyNavigationBar(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(heading: "AUTO SWITCHES"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.03),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(5, 5),
                    ),
                  ],
                  color: appBarColour,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AUTO SWITCH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<List<RouterDetails>>(
                      future: fetchRouters(),
                      builder: (context, routerSnapshot) {
                        if (routerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                              color: backGroundColourDark);
                        }
                        if (routerSnapshot.hasError) {
                          return const Text("ERROR");
                        }
                        final List<RouterDetails> routers =
                            routerSnapshot.data ?? [];
                        bool isConnected = routers.any((router) {
                          return _connectionStatus.contains(router.name);
                        });

                        return Switch(
                          onChanged: (value) async {
                            if (isConnected) {
                              await _saveMainSwitchState(value);
                              for (var switchDetails in routers) {
                                try {
                                  await ApiConnect.hitApiPost(
                                      "${switchDetails.iPAddress}/getSwitchcmd",
                                      {
                                        "Lock_id": switchDetails.switchID,
                                        "lock_passkey":
                                            switchDetails.switchPasskey,
                                        "lock_cmd": value ? "ON" : "OFF",
                                      }).timeout(const Duration(seconds: 2));
                                } catch (e) {
                                  print(
                                      'API call to ${switchDetails.iPAddress} timed out.');
                                }
                              }
                              setState(() {
                                isSwitchOn = value;
                              });
                            } else {
                              showToast(context,
                                  "Please connect any of the Router to proceed");
                            }
                          },
                          value: isSwitchOn && isConnected,
                          activeColor: greenButtonColour,
                          activeTrackColor: greenColour,
                          inactiveThumbColor: redButtonColour,
                          inactiveTrackColor: redColour,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            FutureBuilder<List<RouterDetails>>(
              future: fetchRouters(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: backGroundColourDark);
                }
                if (snapshot.hasError) {
                  return const Text("ERROR");
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return AutoSwitch(switchDetails: snapshot.data![index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
