import 'package:flutter/material.dart';

import '../constants.dart';
import '../controllers/storage.dart';
import '../models/group_model.dart';
import '../widgets/group_card.dart';
import 'add_group.dart';
import 'connect_to_group.dart';

class GroupingPage extends StatelessWidget {
  GroupingPage({super.key});

  final StorageController _storageController = StorageController();

  Future<List<GroupDetails>> fetchGroups() async {
    return _storageController.readAllGroups();
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
                "Add Group",
                style: TextStyle(
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: backGroundColour),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewGroupInstallationPage(),
              ),
            );
          },
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "GROUPS",
            style: TextStyle(
                color: appBarColour, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<GroupDetails>>(
                future: fetchGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: backGroundColourDark));
                  }
                  if (snapshot.hasError)
                    return const Center(child: Text("ERROR"));
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
                              builder: (context) => ConnectToGroupWidget(
                                groupName: snapshot.data![index].groupName,
                                selectedRouter:
                                    snapshot.data![index].selectedRouter,
                                selectedSwitches:
                                    snapshot.data![index].selectedSwitches,
                              ),
                            ),
                          );
                        },
                        child: GroupCard(groupDetails: snapshot.data![index]),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
