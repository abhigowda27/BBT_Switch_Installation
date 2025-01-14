import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/storage.dart';
import '../models/switch_model.dart';
import '../widgets/switch_card.dart';
import 'connect_to_switch.dart';
import 'gallery_qr.dart';
import 'qr_view.dart';

class SwitchPage extends StatelessWidget {
  SwitchPage({super.key});
  final StorageController _storageController = StorageController();

  Future<List<SwitchDetails>> fetchSwitches() async {
    return _storageController.readSwitches();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 70,
        width: 150,
        child: FloatingActionButton.large(
          backgroundColor: appBarColour, // Change this to your desired color
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRView(),
                  ));
                },
                icon: Icon(Icons.camera_alt_outlined, color: backGroundColour),
              ),
              VerticalDivider(
                color: whiteColour,
                thickness: 2,
                endIndent: 20,
                indent: 20,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GalleryQRPage(),
                  ));
                },
                icon: Icon(Icons.image_outlined, color: backGroundColour),
              ),
            ],
          ),
          onPressed: () {},
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "SWITCHES",
            style: TextStyle(
                color: appBarColour, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchSwitches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(color: backGroundColourDark);
                }
                // if (snapshot.hasError) return  Text("ERROR $e");

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectToSwitchWidget(
                              switchName: snapshot.data![index].switchSSID,
                              IP: snapshot.data![index].iPAddress,
                              switchID: snapshot.data![index].switchId,
                              switchPassKey:
                                  snapshot.data![index].switchPassKey!,
                            ),
                          ),
                        );
                      },
                      child:
                          SwitchesCard(switchesDetails: snapshot.data![index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
