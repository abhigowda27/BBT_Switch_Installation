import 'package:bbt_switch/constants.dart';

import '../widgets/toast.dart';
import 'package:flutter/material.dart';
import '../controllers/storage.dart';
import '../models/contacts.dart';
import '../models/switch_model.dart';
import '../models/router_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/qr.dart';
import '../models/group_model.dart';

class ShareQRPage extends StatefulWidget {
  final SwitchDetails? switchDetails;
  final RouterDetails? routerDetails;
  final GroupDetails? groupDetails;

  const ShareQRPage({super.key, this.switchDetails, this.routerDetails, this.groupDetails});

  @override
  State<ShareQRPage> createState() => _ShareQRPageState();
}

class _ShareQRPageState extends State<ShareQRPage> {
  final StorageController _storageController = StorageController();

  List<ContactsModel> contacts = [];

  getData() async {
    contacts = await _storageController.readContacts();
    return (contacts,);
  }

  ContactsModel contact = ContactsModel(
      accessType: "default",
      endDateTime: DateTime.now(),
      startDateTime: DateTime.now(),
      name: "default");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(heading: "Share QR"),
      ),
      body: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: backGroundColourDark);
            }
            var x = snapshot.data as (List<ContactsModel>,);
            contacts = x.$1;
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Select Contact"),
                DropdownMenu(
                  onSelected: (value) async {
                    contact = await _storageController.getContactByPhone(value);
                  },
                  dropdownMenuEntries: contacts
                      .map((e) => DropdownMenuEntry(value: e.name, label: e.name))
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (contact.accessType.contains("default")) {
                          showToast(context, "No contact is selected");
                          return;
                        }
                        String qrData;
                        if (widget.switchDetails != null) {
                          qrData = "${widget.switchDetails!.toSwitchQR()},${contact.toContactsQR()}";
                        } else if (widget.routerDetails != null) {
                          qrData = "${widget.routerDetails!.toRouterQR()},${contact.toContactsQR()}";
                        } else if (widget.groupDetails != null) {
                          qrData = "${widget.groupDetails!.toGroupQR()},${contact.toContactsQR()}";
                        } else {
                          showToast(context, "No details available to share");
                          return;
                        }
                        String name;
                        if (widget.switchDetails != null) {
                          name = widget.switchDetails!.switchSSID;
                        } else if (widget.routerDetails != null) {
                          name = "${widget.routerDetails!.name}_${widget.routerDetails!.switchName}";
                        } else if (widget.groupDetails != null) {
                          name = widget.groupDetails!.groupName;
                        } else {
                          showToast(context, "No details available to share");
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRPage(data: qrData, name: name,),
                          ),
                        );
                      },
                      child: Text("Generate", style: TextStyle(color: appBarColour),),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel",style: TextStyle(color: appBarColour),),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
