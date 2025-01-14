import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../controllers/storage.dart';
import '../models/switch_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/toast.dart';

class NewInstallationPage extends StatefulWidget {
  const NewInstallationPage({required this.switchDetails, super.key});

  final SwitchDetails switchDetails;

  @override
  State<NewInstallationPage> createState() => _NewInstallationPageState();
}

class _NewInstallationPageState extends State<NewInstallationPage> {
  final StorageController _storageController = StorageController();
  final TextEditingController _switchId = TextEditingController();
  final TextEditingController _passKey = TextEditingController();
  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _privatePin = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: CustomAppBar(heading: "New Switch Installation")),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _switchId,
                      validator: (value) {
                        if (value!.isEmpty) return "Switch ID cannot be empty";
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "SwitchID",
                        labelStyle: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    TextFormField(
                      controller: _ssid,
                      validator: (value) {
                        if (value!.isEmpty) return "SSID cannot be empty";
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "New Switch Name",
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
                          return "Switch Password cannot be less than 8 letters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "New Password",
                        labelStyle: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    TextFormField(
                      maxLength: 4,
                      controller: _privatePin,
                      validator: (value) {
                        if (value!.length <= 3) {
                          return "Switch Pin cannot be less than 4 letters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "New Pin",
                        labelStyle: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "PassKey Cannot be empty";
                        }
                        if (value.length <= 7) {
                          return "PassKey Cannot be less than 8 letters";
                        }
                        final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                        if (validCharacters.hasMatch(value)) {
                          return "Passkey should be alphanumeric";
                        }
                        return null;
                      },
                      controller: _passKey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "New Passkey",
                        labelStyle: TextStyle(fontSize: width * 0.035),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomButton(
                      width: 200,
                      text: "Submit",
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          SwitchDetails switchDetails = SwitchDetails(
                              privatePin: _privatePin.text,
                              switchId: _switchId.text,
                              switchSSID: _ssid.text,
                              switchPassKey: _passKey.text,
                              switchPassword: _password.text,
                              iPAddress: widget.switchDetails.iPAddress);
                          bool exist =
                              await _storageController.isSwitchSSIDExists(
                                  switchDetails.switchSSID,
                                  switchDetails.switchId);
                          if (exist) {
                            showToast(context,
                                "Switch Name or Switch Id already exists.");
                            return;
                          } else {
                            try {
                              await ApiConnect.hitApiGet(
                                "$routerIP/",
                              );
                              await ApiConnect.hitApiPost(
                                  "$routerIP/settings", {
                                "Lock_id": _switchId.text,
                                "lock_name": _ssid.text,
                                "lock_pass": _password.text
                              });
                              await ApiConnect.hitApiGet(
                                "$routerIP/",
                              );
                              await ApiConnect.hitApiPost(
                                  "$routerIP/getSecretKey", {
                                "Lock_id": switchDetails.switchId,
                                "lock_passkey": _passKey.text
                              });
                              _storageController.addSwitches(switchDetails);
                              Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const MyNavigationBar(),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              await ApiConnect.hitApiGet(
                                "$routerIP/",
                              );
                              await ApiConnect.hitApiPost(
                                  "$routerIP/getSecretKey", {
                                "Lock_id": switchDetails.switchId,
                                "lock_passkey": _passKey.text
                              });
                              _storageController.addSwitches(switchDetails);
                              Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      const MyNavigationBar(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
