import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

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
import '../models/router_model.dart';
import '../models/switch_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/toast.dart';

class NewRouterInstallationPage extends StatefulWidget {
  String? switchId;
  String? switchSSID;
  String? switchPassKey;
  bool isFromSwitch;
  NewRouterInstallationPage(
      {super.key,
      required this.isFromSwitch,
      this.switchId,
      this.switchSSID,
      this.switchPassKey});

  @override
  State<NewRouterInstallationPage> createState() =>
      _NewRouterInstallationPageState();
}

class _NewRouterInstallationPageState extends State<NewRouterInstallationPage> {
  StorageController _storage = StorageController();
  final TextEditingController _switchId = TextEditingController();
  final TextEditingController _switchName = TextEditingController();
  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String switchID;
  late String switchName;
  late String? passKey;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    if (widget.isFromSwitch) {
      switchID = widget.switchId!;
      switchName = widget.switchSSID!;
      passKey = widget.switchPassKey!;
    } else {
      getSwitchDetails();
    }
  }

  getSwitchDetails() async {
    List<SwitchDetails> switches = await _storage.readSwitches();
    String ssid = _connectionStatus.substring(1, _connectionStatus.length - 1);
    print(ssid);
    for (var element in switches) {
      if (ssid == element.switchSSID) {
        setState(() {
          print(element.switchId);
          passKey = element.switchPassKey!;
          switchID = element.switchId;
          switchName = element.switchSSID;
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    for (var result in results) {
      _initNetworkInfo();
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
    } catch (e) {}

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

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomAppBar(heading: "Add Router")),
        body: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _ssid,
                    validator: (value) {
                      if (value!.isEmpty) return "SSID cannot be empty";
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Router Name",
                      labelStyle: TextStyle(fontSize: width * 0.035),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  TextFormField(
                    controller: _password,
                    validator: (value) {
                      if (value!.length <= 7) {
                        return "Router Password cannot be less than 8 letters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Router Password",
                      labelStyle: TextStyle(fontSize: width * 0.035),
                    ),
                  ),
                  Spacer(),
                  if (loading)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
                      child: InkWell(
                        splashColor: backGroundColour,
                        // onTap: onPressed,
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: backGroundColour ?? backGroundColour,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color: backGroundColour ?? backGroundColour,
                                offset: const Offset(0, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: backGroundColour ?? backGroundColour,
                              width: 1,
                            ),
                          ),
                          alignment: const AlignmentDirectional(0, 0),
                          child: CircularProgressIndicator(
                            color: appBarColour,
                          ),
                        ),
                      ),
                    )
                  else
                    CustomButton(
                      width: 200,
                      text: "Submit",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            setState(() {
                              loading = true;
                            });
                            if (!widget.isFromSwitch) {
                              await getSwitchDetails();
                            }
                            String ssidd = _connectionStatus.substring(
                                1, _connectionStatus.length - 1);
                            if (passKey == null) {
                              showToast(context,
                                  "No switch found with switch $ssidd");
                              setState(() {
                                loading = false;
                              });
                              return;
                            }
                            String? existedRouter = await _storage
                                .getRouterNameIfSwitchIDExists(switchID);
                            if (existedRouter == _ssid.text) {
                              showToast(context,
                                  "SwitchId is already Exist with this router");
                              setState(() {
                                loading = false;
                              });
                              return;
                            }
                            if (existedRouter != null) {
                              showDialog(
                                context: context,
                                builder: (cont) {
                                  return AlertDialog(
                                    title: const Text('Update Router'),
                                    content: const Text(
                                        'SwitchId is already Exist, Do you want to update the existing router'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            loading = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(color: appBarColour),
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          try {
                                            await ApiConnect.hitApiGet(
                                                "$routerIP/");
                                            var res =
                                                await ApiConnect.hitApiPost(
                                                    "$routerIP/getWifiParem", {
                                              "router_ssid": _ssid.text,
                                              "router_password": _password.text,
                                              "switch_passkey": passKey,
                                            });
                                            String IPAddr = res['IPAddress'];
                                            if (IPAddr.contains("0.0.0.0")) {
                                              showToast(context,
                                                  "Unable to connect to IP. Try again.");
                                              return;
                                            }
                                            RouterDetails routerDetails =
                                                RouterDetails(
                                              switchID: switchID,
                                              switchName: switchName,
                                              name: _ssid.text,
                                              password: _password.text,
                                              switchPasskey: passKey!,
                                              iPAddress: res['IPAddress'],
                                            );
                                            await _storage
                                                .updateRouter(routerDetails);
                                            Navigator.pushAndRemoveUntil<
                                                dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        const MyNavigationBar(),
                                              ),
                                              (route) => false,
                                            );
                                          } catch (e) {
                                            print("Error inside updating");
                                            print(e);
                                            showToast(context,
                                                "Error: ${e.toString()}");
                                          }
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
                              return;
                            } else {
                              showToast(context,
                                  "You are connected to $_connectionStatus");
                              await ApiConnect.hitApiGet(
                                routerIP + "/",
                              );
                              print({
                                "router_ssid": _ssid.text,
                                "router_password": _password.text,
                                "switch_passkey": passKey,
                              });
                              var res = await ApiConnect.hitApiPost(
                                  "$routerIP/getWifiParem", {
                                "router_ssid": _ssid.text,
                                "router_password": _password.text,
                                "switch_passkey": passKey,
                              });
                              String IPAddr = res['IPAddress'];
                              if (IPAddr.contains("0.0.0.0")) {
                                showToast(context,
                                    "Unable to connect IP. Try Again.");
                                setState(() {
                                  loading = false;
                                });
                                return;
                              }
                              setState(() {
                                loading = false;
                              });
                              RouterDetails routerDetails = RouterDetails(
                                  switchID: switchID,
                                  switchName: switchName,
                                  name: _ssid.text,
                                  password: _password.text,
                                  switchPasskey: passKey!,
                                  iPAddress: res['IPAddress']);
                              setState(() {
                                loading = true;
                              });
                              _storage.addRouters(routerDetails);
                              setState(() {
                                loading = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyNavigationBar()));
                            }
                          } catch (e) {
                            print("error ${e.toString()}");
                            showToast(context, "Unable to connect. Try Again.");
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      },
                    )
                ],
              ),
            ),
          ),
        ));
  }
}
