import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import '../constants.dart';
import '../models/switch_initial.dart';
import 'newswitchinstallation.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_appbar.dart';

class GalleryQRPage extends StatefulWidget {
  const GalleryQRPage({Key? key}) : super(key: key);

  @override
  State<GalleryQRPage> createState() => _GalleryQRPageState();
}

class _GalleryQRPageState extends State<GalleryQRPage> {
  SwitchDetails details = SwitchDetails(
    switchld: "Unknown",
    switchSSID: "Unknown",
    switchPassword: "Unknown",
    isAutoSwitch: false,
    privatePin: "1234",
    iPAddress: "Unknown",
  );

  @override
  void initState() {
    super.initState();
    scanQR();
  }

  Future<void> scanQR() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        String? barcodeScanRes = await Scan.parse(pickedFile.path);
        if (barcodeScanRes != null) {
          setState(() {
            var jsonR = json.decode(barcodeScanRes);
            details = SwitchDetails(
              switchld: jsonR['LockId'],
              isAutoSwitch: false,
              privatePin: "1234",
              switchSSID: jsonR['LockSSID'],
              switchPassword: jsonR['LockPassword'].toString(),
              iPAddress: jsonR['IPAddress']
            );
          }
          );
        } else {
          // Handle null result from QR parsing
          // You can show an error message or take appropriate action
          print("QR code not found in the selected image.");
        }
      } catch (e) {
        print(e);
      }
    }
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
