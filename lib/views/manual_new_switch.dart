import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../controllers/storage.dart';
import '../models/switch_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class switchInstallationPage extends StatefulWidget {
  switchInstallationPage({super.key});

  @override
  State<switchInstallationPage> createState() => _NewInstallationPageState();
}

class _NewInstallationPageState extends State<switchInstallationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _switchId = TextEditingController();
  final TextEditingController _passKey = TextEditingController();
  final StorageController _storageController = StorageController();
  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _privatePin = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(heading: "New AP Installation")),
        body: Center(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _switchId,
                    validator: (value) {
                      if (value!.length <= 0)
                        return "Switch ID cannot be empty";
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "SwitchID",
                      labelStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _ssid,
                    validator: (value) {
                      if (value!.length <= 0) return "SSID cannot be empty";
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Switch Name",
                      labelStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _password,
                    validator: (value) {
                      if (value!.length <= 7) {
                        return "Switch Password cannot be less than 8 letters";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Password",
                      labelStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    maxLength: 4,
                    controller: _privatePin,
                    validator: (value) {
                      if (value!.length <= 3) {
                        return "Switch Pin cannot be less than 4 letters";
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Pin",
                      labelStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                        borderRadius: BorderRadius.circular(20),
                        // borderSide: BorderSide(width: 40),
                      ),
                      labelText: "New Passkey",
                      labelStyle: const TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                          iPAddress: routerIP,
                        );
                        try {
                          await ApiConnect.hitApiGet(
                            routerIP + "/",
                          );

                          await ApiConnect.hitApiPost("$routerIP/settings", {
                            "Lock_id": _switchId.text,
                            "lock_name": _ssid.text,
                            "lock_pass": _password.text
                          });

                          await ApiConnect.hitApiGet(
                            routerIP + "/",
                          );

                          await ApiConnect.hitApiPost(
                              routerIP + "/getSecretKey", {
                            "Lock_id": switchDetails.switchId,
                            "lock_passkey": _passKey.text
                          });

                          _storageController.addSwitches(switchDetails);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  MyNavigationBar(),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          );
                        } catch (e) {
                          await ApiConnect.hitApiGet(
                            routerIP + "/",
                          );

                          await ApiConnect.hitApiPost(
                              routerIP + "/getSecretKey", {
                            "Lock_id": switchDetails.switchId,
                            "lock_passkey": _passKey.text
                          });
                          _storageController.addSwitches(switchDetails);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  MyNavigationBar(),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          );
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
