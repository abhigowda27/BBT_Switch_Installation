import 'package:flutter/material.dart';
import '../constants.dart';
import '../controllers/storage.dart';
import '../models/group.dart';
import '../widgets/group_card.dart';
import 'ConnectToGroup.dart';
import 'add_group.dart';

class GroupingPage extends StatelessWidget {
  GroupingPage({super.key});

  final StorageController _storageController = StorageController();

  Future<List<GroupDetails>> fetchGroups() async {
    return _storageController.readAllGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 120,
        width: 120,
        child: FloatingActionButton.large(
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 30,
              ),
              Text(
                "Add Group",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewGroupInstallationPage(),
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
              color: appBarColour,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [],
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) return const Center(child: Text("ERROR"));
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
                            selectedRouter: snapshot.data![index].selectedRouter,
                            selectedSwitches: snapshot.data![index].selectedSwitches,
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
