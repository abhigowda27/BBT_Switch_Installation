import '../bottom_nav_bar.dart';
import '../controllers/storage.dart';
import '../models/group.dart';
import '../models/router_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/toast.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class NewGroupInstallationPage extends StatefulWidget {
  const NewGroupInstallationPage({super.key});

  @override
  State<NewGroupInstallationPage> createState() => _NewGroupInstallationPageState();
}

class _NewGroupInstallationPageState extends State<NewGroupInstallationPage> {
  final StorageController _storage = StorageController();
  final TextEditingController _groupName = TextEditingController();
  bool loading = false;
  List<RouterDetails> selectedSwitches = [];
  List<RouterDetails> availableSwitches = [];
  String? selectedRouter;
  List<RouterDetails> availableRouters = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableRouters();
  }

  void fetchAvailableSwitches(String routerName) async {
    try {
      List<RouterDetails> allSwitches = await _storage.readRouters();
      List<RouterDetails> filteredSwitches = allSwitches.where((switchItem) => switchItem.name == routerName).toList();

      setState(() {
        availableSwitches = filteredSwitches;
      });
    } catch (e) {
      showToast(context, "Error fetching switches");
    }
  }

  void fetchAvailableRouters() async {
    try {
      List<RouterDetails> routers = await _storage.readRouters();
      Set<String> seenNames = Set();
      List<RouterDetails> uniqueRouters = [];

      for (var router in routers) {
        if (!seenNames.contains(router.name)) {
          seenNames.add(router.name);
          uniqueRouters.add(router);
        }
      }
      setState(() {
        availableRouters = uniqueRouters;
      });
    } catch (e) {
      showToast(context, "Error fetching routers");
    }
  }

  void handleRouterChange(String? selectedRouter) {
    setState(() {
      this.selectedRouter = selectedRouter;
      if (selectedRouter != null) {
        fetchAvailableSwitches(selectedRouter);
      } else {
        availableSwitches = [];
        selectedSwitches = [];
      }
    });
  }

  Future<void> handleSubmit() async {
    if (_groupName.text.isEmpty) {
      showToast(context, "Group name cannot be empty.");
      return;
    }
    String groupName = _groupName.text;
    bool groupExists = await _storage.groupExists(groupName);
    if (groupExists) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Group Name Already Exists"),
            content: const Text("Do you want to update the existing group?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await _storage.updateGroupDetails(groupName, selectedRouter!, selectedSwitches);
                  Navigator.of(context).pop();
                  showToast(context, "Group updated successfully.");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyNavigationBar(),
                    ),
                  );
                },
                child: const Text("Update"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        setState(() {
          loading = true;
        });

        GroupDetails groupDetails = GroupDetails(
          groupName: groupName,
          selectedRouter: selectedRouter!,
          selectedSwitches: selectedSwitches,
        );

        await _storage.saveGroupDetails(groupDetails);

        setState(() {
          loading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyNavigationBar(),
          ),
        );
      } catch (e) {
        showToast(context, "Unable to connect. Try Again.");
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(heading: "Add Group"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _groupName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "New Group Name",
                  labelStyle: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Select Router",
                  labelStyle: const TextStyle(fontSize: 15),
                ),
                value: selectedRouter,
                onChanged: handleRouterChange,
                items: availableRouters
                    .map((routerItem) => DropdownMenuItem(
                  value: routerItem.name,
                  child: Text(routerItem.name),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text("Selected Router:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (selectedRouter != null)
                ListTile(
                  title: Text(selectedRouter!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        selectedRouter = null;
                        availableSwitches = [];
                        selectedSwitches = [];
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              DropdownButtonFormField<RouterDetails>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Select Switches",
                  labelStyle: const TextStyle(fontSize: 15),
                ),
                value: null,
                onChanged: (selectedSwitch) {
                  setState(() {
                    if (selectedSwitch != null && !selectedSwitches.contains(selectedSwitch)) {
                      selectedSwitches.add(selectedSwitch);
                    }
                  });
                },
                items: availableSwitches
                    .map((switchItem) => DropdownMenuItem(
                  value: switchItem,
                  child: Text("${switchItem.name}_${switchItem.switchName}"),
                ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text("Selected Switches:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: selectedSwitches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(selectedSwitches[index].switchName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            selectedSwitches.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                text: "Submit",
                onPressed: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
