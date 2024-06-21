import '../views/switches_page.dart';
import '../widgets/toast.dart';
import 'package:dio/dio.dart';
import '../bottom_nav_bar.dart';
import '../controllers/storage.dart';
import '../models/switch_initial.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../controllers/apis.dart';
import '../widgets/custom_appbar.dart';

class UpdateSwitchInstallationPage extends StatefulWidget {
  UpdateSwitchInstallationPage({required this.switchDetails, super.key});

  final SwitchDetails switchDetails;

  @override
  State<UpdateSwitchInstallationPage> createState() =>
      _UpdateSwitchInstallationPageState();
}

class _UpdateSwitchInstallationPageState
    extends State<UpdateSwitchInstallationPage> {
  @override
  void initState() {
    // TODO: implement initState
    _password.text = widget.switchDetails.switchPassword;
    _password1.text = widget.switchDetails.switchPassword;
    _ssid.text = widget.switchDetails.switchSSID;
    _passKey.text = widget.switchDetails.switchPassKey!;
    _privatePin.text = widget.switchDetails.privatePin;
    super.initState();
  }

  // final TextEditingController _switchId = TextEditingController();

  final TextEditingController _ssid = TextEditingController();
  final TextEditingController _passKey = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final TextEditingController _privatePin = TextEditingController();
  StorageController _storageController = new StorageController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: CustomAppBar(heading: "AP Updation")),
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
                      if (value!.length <= 7)
                        return "Switch Password cannot be less than 8 letters";
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
                    controller: _password1,
                    validator: (value) {
                      if (value!.length <= 7)
                        return "Switch Password cannot be less than 8 letters";
                      if (_password.text != _password1.text)
                        return "Passwords do not match";
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
                  // const SizedBox(
                  //   height: 20,
                  // ),
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
                  loading
                      ? Align(
                    // alignment: AlignmentDirectional(1, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16, 0, 16, 16),
                      child: InkWell(
                        splashColor: backGroundColour,
                        // onTap: onPressed,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: BoxDecoration(
                            color: backGroundColour ?? backGroundColour,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                color:
                                backGroundColour ?? backGroundColour,
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
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )
                  :CustomButton(
                    width: 200,
                    text: "Submit",
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // if (_passKey.text != widget.switchDetails.switchPassKey) {
                        //   showToast(context,
                        //       "Passkey of the switch is incorrect. Try Again.");
                        //   return;
                        // }
                        // if (_privatePin.text != widget.switchDetails.privatePin) {
                        //   showToast(context,
                        //       "Private Pin of the switch is incorrect. Try Again.");
                        //   return;
                        // }
                        SwitchDetails switchDetails1 = SwitchDetails(
                            isAutoSwitch: widget.switchDetails.isAutoSwitch,
                            privatePin: _privatePin.text,
                            switchld: widget.switchDetails.switchld,
                            switchSSID: _ssid.text,
                            switchPassKey: _passKey.text,
                            switchPassword: _password.text,
                            iPAddress: widget.switchDetails.iPAddress,
                        );

                        try {
                          setState(() {
                            loading = true;
                          });
                          await ApiConnect.hitApiGet(
                            routerIP + "/",
                          );
                          var data = {
                            "Lock_id": widget.switchDetails.switchld,
                            "lock_name": _ssid.text,
                            "lock_pass": _password.text
                          };
                          print(data);
                          await ApiConnect.hitApiPost(
                              "$routerIP/settings", data
                          );

                          await ApiConnect.hitApiPost(
                              "$routerIP/getSecretKey", {
                            "Lock_id": switchDetails1.switchld,
                            "lock_passkey": _passKey.text
                          });
                          _storageController.updateSwitch(
                              switchDetails1.switchld, switchDetails1);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  MyNavigationBar(),
                            ),
                            (route) => false,
                          );
                        } on DioException {
                          await ApiConnect.hitApiGet(
                            routerIP + "/",
                          );
                          await ApiConnect.hitApiPost(
                              "$routerIP/getSecretKey", {
                            "Lock_id": switchDetails1.switchld,
                            "lock_passkey": _passKey.text
                          });
                          _storageController.updateSwitch(
                              switchDetails1.switchld, switchDetails1);
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) =>
                                  MyNavigationBar(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          print(e.toString());
                          showToast(context, "Failed to Update. Try again");
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
