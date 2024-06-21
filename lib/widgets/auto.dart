// import 'dart:async';
// import 'dart:io';
// import 'dart:developer' as developer;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:lamp_a3/views/AutoSwitchPage.dart';
// import 'package:lamp_a3/widgets/toast.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../bottom_nav_bar.dart';
// import '../controllers/apis.dart';
// import '../controllers/permission.dart';
// import '../controllers/storage.dart';
// import '../models/router_model.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../constants.dart';
// import '../views/router_page.dart';
//
// class AutoRouterCard extends StatefulWidget {
//   final RouterDetails routerDetails;
//   AutoRouterCard({
//     required this.routerDetails,
//     super.key,
//   });
//   @override
//   _AutoRouterCardState createState() => _AutoRouterCardState();
// }
//
// class _AutoRouterCardState extends State<AutoRouterCard> {
//   late bool isSwitchOn = false; // Initialize isSwitchOn as false
//   final StorageController _storageController = StorageController();
//   Future<List<RouterDetails>> fetchRouters() async {
//     return _storageController.readRouters();
//   }
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//
//   ConnectivityResult _connectionStatusS = ConnectivityResult.none;
//   final Connectivity _connectivity = Connectivity();
//   StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _initNetworkInfo();
//
//     connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
//       _updateConnectionStatus(results);
//     });
//   }
//
//   @override
//   void dispose() {
//     connectivitySubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
//     for (var result in results) {
//       _initNetworkInfo(); // Process each result as needed
//     }
//   }
//   String _connectionStatus = 'Unknown';
//   final NetworkInfo _networkInfo = NetworkInfo();
//   Future<void> _initNetworkInfo() async {
//     String? wifiName,
//         wifiBSSID,
//         wifiIPv4,
//         wifiIPv6,
//         wifiGatewayIP,
//         wifiBroadcast,
//         wifiSubmask;
//
//     try {
//       await requestPermission(Permission.nearbyWifiDevices);
//       // await requestPermission(Permission.locationWhenInUse);
//     } catch (e) {
//       print(e.toString());
//     }
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiName = await _networkInfo.getWifiName();
//         } else {
//           wifiName = await _networkInfo.getWifiName();
//         }
//       } else {
//         wifiName = await _networkInfo.getWifiName();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi Name', error: e);
//       wifiName = 'Failed to get Wifi Name';
//     }
//
//     try {
//       if (!kIsWeb && Platform.isIOS) {
//         // ignore: deprecated_member_use
//         var status = await _networkInfo.getLocationServiceAuthorization();
//         if (status == LocationAuthorizationStatus.notDetermined) {
//           // ignore: deprecated_member_use
//           status = await _networkInfo.requestLocationServiceAuthorization();
//         }
//         if (status == LocationAuthorizationStatus.authorizedAlways ||
//             status == LocationAuthorizationStatus.authorizedWhenInUse) {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         } else {
//           wifiBSSID = await _networkInfo.getWifiBSSID();
//         }
//       } else {
//         wifiBSSID = await _networkInfo.getWifiBSSID();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi BSSID', error: e);
//       wifiBSSID = 'Failed to get Wifi BSSID';
//     }
//
//     try {
//       wifiIPv4 = await _networkInfo.getWifiIP();
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi IPv4', error: e);
//       wifiIPv4 = 'Failed to get Wifi IPv4';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiIPv6 = await _networkInfo.getWifiIPv6();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi IPv6', error: e);
//       wifiIPv6 = 'Failed to get Wifi IPv6';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiSubmask = await _networkInfo.getWifiSubmask();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi submask address', error: e);
//       wifiSubmask = 'Failed to get Wifi submask address';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiBroadcast = await _networkInfo.getWifiBroadcast();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi broadcast', error: e);
//       wifiBroadcast = 'Failed to get Wifi broadcast';
//     }
//
//     try {
//       if (!Platform.isWindows) {
//         wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
//       }
//     } on PlatformException catch (e) {
//       developer.log('Failed to get Wifi gateway address', error: e);
//       wifiGatewayIP = 'Failed to get Wifi gateway address';
//     }
//
//     setState(() {
//       _connectionStatus = wifiName!.toString();
//       // 'Wifi BSSID: $wifiBSSID\n'
//       // 'Wifi IPv4: $wifiIPv4\n'
//       // 'Wifi IPv6: $wifiIPv6\n'
//       // 'Wifi Broadcast: $wifiBroadcast\n'
//       // 'Wifi Gateway: $wifiGatewayIP\n'
//       // 'Wifi Submask: $wifiSubmask\n';
//     }
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0), // Adjusted padding for reduced container size
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade400,
//             spreadRadius: 5,
//             blurRadius: 7,
//             offset: const Offset(5, 5), // changes position of shadow
//           ),
//         ],
//             color: appBarColour, borderRadius: BorderRadius.circular(10)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'MAIN SWITCH',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             FutureBuilder(
//               future: fetchRouters(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 }
//                 final router = snapshot.data![0] as RouterDetails;
//                 return Switch(
//                   onChanged: (value) async {
//                     String localConnectStatus = _connectionStatus;
//                     localConnectStatus = localConnectStatus.substring(1, localConnectStatus.length - 1);
//                     if (localConnectStatus != router.name) {
//                       showToast(context,
//                           "You should be connected to ${router.name} to refresh the switch settings");
//                       setState(() {
//                         isSwitchOn = !value;
//                       });
//                       return;
//                     }
//                     if (value) {
//                       ApiConnect.hitApiPost("${router.iPAddress}/getSwitchcmd", {
//                         "Lock_id": router.switchID,
//                         "lock_passkey": router.switchPasskey,
//                         "lock_cmd": "ON",
//                       });
//                     } else {
//                       ApiConnect.hitApiPost("${router.iPAddress}/getSwitchcmd", {
//                         "Lock_id": router.switchID,
//                         "lock_passkey": router.switchPasskey,
//                         "lock_cmd": "OFF",
//                       });
//                     }
//                     await _storageController.updateSwitchAutoStatus(
//                       router.name,
//                       value,
//                     );
//                     // Navigator.pushAndRemoveUntil<dynamic>(
//                     //   context,
//                     //   MaterialPageRoute<dynamic>(
//                     //     builder: (BuildContext context) => AutoSwitchPage(),
//                     //   ),
//                     //       (route) => false, //if you want to disable back feature set to false
//                     // );
//                   },
//                   value: isSwitchOn, // Set switch value
//                   activeColor: appBarColour,
//                   activeTrackColor: backGroundColour,
//                   inactiveThumbColor: blackColour,
//                   inactiveTrackColor: whiteColour,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }