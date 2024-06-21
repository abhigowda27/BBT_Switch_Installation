import '../constants.dart';
import '../models/switch_initial.dart';
import 'connectToSwitch.dart';
import 'gallery_qr.dart';
import 'qr_view.dart';
import '../widgets/switch_card.dart';
import 'package:flutter/material.dart';
import '../controllers/storage.dart';

class SwitchPage extends StatelessWidget {
  SwitchPage({super.key});
  final StorageController _storageController = StorageController();

  Future<List<SwitchDetails>> fetchSwitches() async {
    return _storageController.readSwitches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 70,
          width: 150,
          child: FloatingActionButton.large(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const QRViewExample(),
                        ));
                      },
                      icon: const Icon(Icons.photo_camera)),
                  // Container(),
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
                      icon: const Icon(Icons.image_outlined)),
                ],
              ),
              onPressed: () {}),
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
                  color: appBarColour,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: fetchSwitches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) return const Text("ERROR");

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
                                        switchID: snapshot.data![index].switchld,
                                        switchPassKey: snapshot.data![index].switchPassKey!,
                                      )
                                  )
                              );
                            },
                            child:
                                SwitchesCard(switchesDetails: snapshot.data![index]));
                        }
                        );
                  }
                  ),
            ],
          ),
        )
    );
  }
}
