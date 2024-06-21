import 'dart:async';
import 'package:lamp_a3/views/AutoSwitchPage.dart';
import 'package:open_settings/open_settings.dart';
import '../controllers/storage.dart';
import '../models/switch_initial.dart';
import 'generate_qr.dart';
import 'mac_details.dart';
import 'pinpage.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../widgets/toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import '../views/QRPin.dart';
import '../controllers/permission.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ConnectivityResult _connectionStatusS = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();

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

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    for (var result in results) {
      _initNetworkInfo(); // Process each result as needed
    }
  }

  String _connectionStatus = 'Unknown';
  StorageController _storageController = StorageController();
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
    return GestureDetector(
      // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            iconTheme: IconThemeData(color: appBarColour),
            backgroundColor: backGroundColour,
            automaticallyImplyLeading: false,
            title: Text(
              "SETTINGS",
              style: TextStyle(
                  color: appBarColour,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'WIFI is connected to Wifi Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Text(
                    _connectionStatus.toString(),
                    style: TextStyle(
                        color: appBarColour,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: "Open WIFI Settings",
                  icon: Icons.wifi_find,
                  onPressed: () {
                    OpenSettings.openWIFISetting();
                  },
                ),
                // CustomButton(
                //   text: "Open Location Settings",
                //   icon: Icons.location_on_outlined,
                //   onPressed: () {
                //     OpenSettings.openLocationSourceSetting();
                //   },
                // ),
                CustomButton(
                  text: "Factory Reset",
                  icon: Icons.lock_reset_rounded,
                  bgmColor: redButtonColour,
                  onPressed: () async {
                    List<SwitchDetails> switches =
                    await _storageController.readSwitches();
                    String localConnectStatus = _connectionStatus;
                    localConnectStatus = localConnectStatus.substring(
                        1, localConnectStatus.length - 1);
                    for (var element in switches) {
                      if (localConnectStatus == (element.switchSSID)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PinCodeWidget(
                                      currentSwitch: _connectionStatus,
                                      switchDetails: element,
                                    )));
                        return;
                      }
                    }
                    showToast(context, "You may not be connected to AP Mode.");
                  },
                ),
                CustomButton(
                    text: "Mac Id",
                    icon: Icons.tablet_mac_rounded,
                    onPressed: () async {
                      List<SwitchDetails> switches =
                      await _storageController.readSwitches();
                      for (var element in switches) {
                        if (_connectionStatus.contains(element.switchSSID)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MacsPage(
                                        switchDetails: element,
                                      )));
                          return;
                        }
                      }
                      showToast(context, "You may not be connected to AP Mode.");
                    }
                    ),
                CustomButton(
                  text: "Generate QR",
                  icon: Icons.qr_code,
                  onPressed: () async {
                    final qrPin = await _storageController.getQrPin();
                    PinDialog pinDialog = PinDialog(context);
                    pinDialog.showPinDialog(
                      isFirstTime: qrPin == null,
                      onSuccess: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenerateQRPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
                CustomButton(
                  text: "AUTO Switch",
                  icon: Icons.hdr_auto_sharp,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AutoSwitchPage()));
                  },
                ),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: Stack(
        //   children: [
        //     Align(
        //       alignment: Alignment.bottomRight,
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           FloatingActionButton(
        //             onPressed: () {
        //               OpenSettings.openWIFISetting();
        //             },
        //             child: const Icon(Icons.wifi_find),
        //             backgroundColor: backGroundColour,
        //           ),
        //           const SizedBox(height: 5), // Adjust spacing between buttons
        //           FloatingActionButton(
        //             onPressed: () {
        //               OpenSettings.openLocationSourceSetting();
        //             },
        //             backgroundColor: backGroundColour,
        //             child: const Icon(Icons.location_on_rounded),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
