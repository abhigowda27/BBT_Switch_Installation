import 'package:flutter/material.dart';
import '../bottom_nav_bar.dart';
import '../controllers/storage.dart';
import '../models/group.dart';
import '../constants.dart';
import '../views/QRPin.dart';
import '../views/sharePage.dart';

class GroupCard extends StatefulWidget {
  final GroupDetails groupDetails;

  GroupCard({required this.groupDetails, Key? key}) : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool hide = true;
  StorageController _storageController = StorageController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(5, 5),
              ),
            ],
            color: whiteColour,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Group Name: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.groupDetails.groupName,
                        style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Selected Router: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.groupDetails.selectedRouter != null)
                      Flexible(
                      child: Text(
                        widget.groupDetails.selectedRouter,
                        style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected Switches:",
                      style: TextStyle(
                        fontSize: 20,
                        color: blackColour,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Wrap the list of switchDetails in a Column to display them line by line
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.groupDetails.selectedSwitches.map((switchDetail) => Text(
                        switchDetail.switchName,
                        style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400,
                        ),
                      )).toList(),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: backGroundColour,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        tooltip: "Delete Group",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (cont) {
                              return AlertDialog(
                                title: const Text('Delete Group'),
                                content: const Text('This will delete the Group'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('CANCEL'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      _storageController.deleteOneGroup(widget.groupDetails);
                                      Navigator.pushAndRemoveUntil<dynamic>(
                                        context,
                                        MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context) =>
                                              MyNavigationBar(),
                                        ),
                                            (route) =>
                                        false, //if you want to disable back feature set to false
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete_outline_outlined),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (cont) {
                                  return AlertDialog(
                                    title: const Text('BBT Switch'),
                                    content:
                                    const Text('Do you want to share the Switch'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          final qrPin = await _storageController.getQrPin();
                                          PinDialog pinDialog = PinDialog(context);
                                          pinDialog.showPinDialog(
                                            isFirstTime: qrPin == null,
                                            onSuccess: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ShareQRPage(groupDetails: widget.groupDetails)
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.share_rounded
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
