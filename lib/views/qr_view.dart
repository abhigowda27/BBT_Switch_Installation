import 'dart:convert';
import '../constants.dart';
import '../models/switch_initial.dart';
import 'newswitchinstallation.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../widgets/custom_appbar.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<QRViewExample> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scanQR();
  }

  String _scanBarcode = 'Unknown';
  SwitchDetails details = SwitchDetails(
      switchld: "Unknown",
      switchSSID: "Unknown",
      switchPassword: "Unknown",
      isAutoSwitch: false,
      privatePin: "1234",
      iPAddress: "Unknown");

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      var jsonR = json.decode(barcodeScanRes);
      details = SwitchDetails(
          switchld: jsonR['LockId'],
          isAutoSwitch: false,
          privatePin: "1234",
          switchSSID: jsonR['LockSSID'],
          switchPassword: jsonR['LockPassword'].toString(),
          iPAddress: jsonR['IPAddress']);
      // details = LockDetails(lockld: barcodeScanRes[''], lockSSID: lockSSID, lockPassword: lockPassword, iPAddress: iPAddress)
    });
  }

  @override
  Widget build(BuildContext context) {
    if (details.switchld == "Unknown")
      return const Center(child: CircularProgressIndicator());
    return GestureDetector(
      // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        // key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(heading: "QR Details")),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .8,
                    height: 180,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(5,
                                5), // changes position of shadow
                          ),
                        ],
                        color: whiteColour,
                        borderRadius: BorderRadius.circular(12)),
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
                              Wrap(
                                children: [
                                  Text(
                                    details.switchld,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackColour,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
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
                              Wrap(
                                children: [
                                  Text(
                                    details.switchSSID,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackColour,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Switch Password : ",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: blackColour,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                details.switchPassword,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: blackColour,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),

                          const Text(
                            "Please NOTE down the password you will need to configure and change the lock",
                            style: TextStyle(fontSize: 18),
                          ),
                          // Text("Start and End Date : 00-00"),
                          // Text("Start and End Time : 00:00-00:00"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  width: 200,
                  text: "Next",
                  onPressed: () {
                    // print('Button pressed ...');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: const Text('Instructions'),
                            content: const Text(
                                'Below to personalize your configuration you are required to change the lock name and password for security purpose.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewInstallationPage(
                                                switchDetails: details,
                                              )));
                                },
                                // Navigator.pop(context, 'Contii'),
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
//
// import 'dart:convert';
// import '../constants.dart';
// import '../models/switch_initial.dart';
// import 'newswitchinstallation.dart';
// import '../widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class QRViewExample extends StatefulWidget {
//   const QRViewExample({super.key});
//
//   @override
//   State<QRViewExample> createState() => _QRViewExampleState();
// }
//
// class _QRViewExampleState extends State<QRViewExample> {
//   TextEditingController switchIdController = TextEditingController();
//   TextEditingController switchSSIDController = TextEditingController();
//   TextEditingController switchPasswordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manual Switch Details Entry'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: switchIdController,
//               decoration: InputDecoration(labelText: 'Switch ID'),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: switchSSIDController,
//               decoration: InputDecoration(labelText: 'Switch Name'),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: switchPasswordController,
//               decoration: InputDecoration(labelText: 'Switch Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//               text: 'Submit',
//               onPressed: () {
//                 String switchId = switchIdController.text;
//                 String switchSSID = switchSSIDController.text;
//                 String switchPassword = switchPasswordController.text;
//
//                 if (switchId.isNotEmpty &&
//                     switchSSID.isNotEmpty &&
//                     switchPassword.isNotEmpty) {
//                   // All fields are filled, proceed with creating LockDetails
//                   SwitchDetails details = SwitchDetails(
//                     switchld: switchId,
//                     switchSSID: switchSSID,
//                     switchPassword: switchPassword,
//                     //isAutoLock: false,
//                     privatePin: "1234",
//                     iPAddress: "Unknown",
//                     isAutoSwitch: true,
//                   );
//
//                   showDialog<String>(
//                     context: context,
//                     builder: (BuildContext context) => AlertDialog(
//                       title: const Text('Instructions'),
//                       content: const Text(
//                           'Below to personalize your configuration you are required to change the switch name and password for security purpose.'),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, 'Cancel'),
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => NewInstallationPage(
//                                   switchDetails: details,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Text('Continue'),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   // Display an error message if any field is empty
//                   showDialog<String>(
//                     context: context,
//                     builder: (BuildContext context) => AlertDialog(
//                       title: const Text('Error'),
//                       content: const Text('Please fill in all fields.'),
//                       actions: <Widget>[
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, 'OK'),
//                           child: const Text('OK'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
