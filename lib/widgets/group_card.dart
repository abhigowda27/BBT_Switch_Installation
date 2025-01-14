import 'package:flutter/material.dart';

import '../bottom_nav_bar.dart';
import '../constants.dart';
import '../controllers/storage.dart';
import '../models/group_model.dart';
import '../models/router_model.dart';

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.groupDetails.selectedSwitches
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        RouterDetails switchDetail = entry.value;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Switch ${index + 1} :',
                              style: TextStyle(
                                fontSize: 20,
                                color: blackColour,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              switchDetail.switchName,
                              style: TextStyle(
                                fontSize: 20,
                                color: blackColour,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    10), // Add some spacing between switches
                          ],
                        );
                      }).toList(),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: appBarColour,
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
                                content:
                                    const Text('This will delete the Group'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'CANCEL',
                                      style: TextStyle(color: appBarColour),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () async {
                                      _storageController
                                          .deleteOneGroup(widget.groupDetails);
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
                                    child: Text(
                                      'OK',
                                      style: TextStyle(color: appBarColour),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.delete_outline_outlined,
                            color: backGroundColour),
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       showDialog(
                      //           context: context,
                      //           builder: (cont) {
                      //             return AlertDialog(
                      //               title: const Text('BBT Switch'),
                      //               content: const Text(
                      //                   'Do you want to share the Switch'),
                      //               actions: [
                      //                 OutlinedButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                   },
                      //                   child:  Text('CANCEL',style: TextStyle(color: appBarColour),),
                      //                 ),
                      //                 OutlinedButton(
                      //                   onPressed: () async {
                      //                     final qrPin = await _storageController
                      //                         .getQrPin();
                      //                     PinDialog pinDialog =
                      //                         PinDialog(context);
                      //                     pinDialog.showPinDialog(
                      //                       isFirstTime: qrPin == null,
                      //                       onSuccess: () {
                      //                         Navigator.push(
                      //                           context,
                      //                           MaterialPageRoute(
                      //                               builder: (context) =>
                      //                                   ShareQRPage(
                      //                                       groupDetails: widget
                      //                                           .groupDetails)),
                      //                         );
                      //                       },
                      //                     );
                      //                   },
                      //                   child:  Text('OK',style: TextStyle(color: appBarColour),),
                      //                 ),
                      //               ],
                      //             );
                      //           });
                      //     },
                      //     icon: Icon(Icons.share_rounded,
                      //         color: backGroundColour))
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
