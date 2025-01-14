import 'package:bbt_switch/views/connect_to_switch.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/storage.dart';
import '../models/router_model.dart';
import '../widgets/router_card.dart';
import 'add_router.dart';

class RouterPage extends StatelessWidget {
  RouterPage({super.key});
  final StorageController _storageController = StorageController();

  Future<List<RouterDetails>> fetchRouters() async {
    return _storageController.readRouters();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 100,
        width: 120,
        child: FloatingActionButton.large(
            backgroundColor: appBarColour,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 30, color: backGroundColour),
                Text(
                  "Add Router",
                  style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: backGroundColour),
                )
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewRouterInstallationPage(
                            isFromSwitch: false,
                          )));
            }),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "ROUTERS",
            style: TextStyle(
                color: appBarColour, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // bottomNavigationBar: MyNavigationBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              FutureBuilder(
                  future: fetchRouters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                          color: backGroundColourDark);
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("ERROR: ${snapshot.error}"));
                    }
                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(snapshot.data![index].switchPasskey);
                              print("snapshot.data![index].switchPasskey");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConnectToSwitchWidget(
                                            isFromRouter: true,
                                            IP: snapshot
                                                .data![index].iPAddress!,
                                            switchName:
                                                snapshot.data![index].name,
                                            switchID:
                                                snapshot.data![index].switchID,
                                            switchPassKey: snapshot
                                                .data![index].switchPasskey,
                                          )));
                            },
                            child: RouterCard(
                                routerDetails: snapshot.data![index]),
                          );
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
