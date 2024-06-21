import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/contacts.dart';
import '../models/group.dart';
import '../models/switch_initial.dart';
import '../models/mac_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/router_model.dart';
import '../widgets/toast.dart';

class StorageController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static const _mainSwitchStateKey = 'isMainSwitchOn';
  static const _groupStateKey = 'isGroupSwitchOn';

  void addContacts(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.add(contactsModel);

    List listContentsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContentsInJson));
  }

  Future<bool> loadMainSwitchState() async {
    String? value = await storage.read(key: _mainSwitchStateKey);
    return value != null && value.toLowerCase() == 'true';
  }

  Future<bool> loadGroupSwitchState() async {
    String? value = await storage.read(key: _groupStateKey);
    return value != null && value.toLowerCase() == 'true';
  }

  Future<void> saveMainSwitchState(bool value) async {
    await storage.write(key: _mainSwitchStateKey, value: value.toString());
  }

  Future<void> saveGroupSwitchState(bool value) async {
    await storage.write(key: _groupStateKey, value: value.toString());
  }


  deleteGroups() async {
    await storage.delete(key: "groups");
  }

  deleteContacts() async {
    await storage.delete(key: "contacts");
  }

  deleteRouters() async {
    await storage.delete(key: "routers");
  }

  deleteSwitches() async {
    await storage.delete(key: "switches");
  }

  deleteMacs() async {
    await storage.delete(key: "macs");
  }

  final String _qrPinKey = 'qrPinKey';

  Future<String?> getQrPin() async {
    return await storage.read(key: _qrPinKey);
  }

  Future<void> setQrPin(String pin) async {
    await storage.write(key: _qrPinKey, value: pin);
  }

  deleteOneContact(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.removeWhere((element) => element.name == contactsModel.name);
    // for (var element in contactList) {
    //   if(element.name == contactsModel.name){}
    // }
    // contactList.(contactsModel);
    List listContectsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContectsInJson));
  }

  Future<List<ContactsModel>> readContacts() async {
    String? contacts = await storage.read(key: "contacts");
    List<ContactsModel> model = [];
    if (contacts == null) {
      List listContectsInJson = model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "contacts", value: json.encode(listContectsInJson));
    } else {
      model = [];
      var jsonContacts = json.decode(contacts);
      for (var element in jsonContacts) {
        model.add(ContactsModel.fromJson(element));
      }
    }
    return model;
  }

  Future<List<SwitchDetails>> readSwitches() async {
    String? switches = await storage.read(key: "switches");
    List<SwitchDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "switches", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      print(jsonContacts);
      for (var element in jsonContacts) {
        _model.add(SwitchDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneSwitch(SwitchDetails switchDetails) async {
    List<SwitchDetails> switchList = await readSwitches();
    switchList.removeWhere((element) => element.switchSSID == switchDetails.switchSSID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    await deleteSwitches();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  Future<void> updateSwitch(String idOfSwitch, SwitchDetails switchDetails) async {
    List<SwitchDetails> switchesList = await readSwitches();
    List<RouterDetails> routersList = await readRouters();

    print("-------------");
    print("Switches before update: ${switchesList.map((e) => e.toJson()).toList()}");
    print("Routers before update: ${routersList.map((e) => e.toJson()).toList()}");

    // Update switch details in the list
    for (var element in switchesList) {
      if (element.switchld == idOfSwitch) {
        element.switchld = switchDetails.switchld;
        element.switchPassword = switchDetails.switchPassword;
        element.switchSSID = switchDetails.switchSSID;
        element.privatePin = switchDetails.privatePin;
        element.switchPassKey = switchDetails.switchPassKey;
        break;
      }
    }

    print("Switches after update: ${switchesList.map((e) => e.toJson()).toList()}");

    // Update the storage for switches
    await deleteSwitches();
    await storage.write(key: "switches", value: json.encode(switchesList.map((e) => e.toJson()).toList()));

    // Update router details if the router is associated with the switch
    for (var element in routersList) {
      if (element.switchID == idOfSwitch) {
        element.switchID = switchDetails.switchld;
        element.switchName = switchDetails.switchSSID;
        element.privatePin = switchDetails.privatePin;
        element.switchPasskey = switchDetails.switchPassKey!;
        // Keep the name, password, and ipAddress the same
        element.name = element.name;
        element.password = element.password;
        element.iPAddress = element.iPAddress;
        break;
      }
    }

    print("Routers after update: ${routersList.map((e) => e.toJson()).toList()}");

    // Update the storage for routers
    await deleteRouters();
    await storage.write(key: "routers", value: json.encode(routersList.map((e) => e.toJson()).toList()));
  }

  updateSwitchAutoStatus(String switchname, bool status) async {
    List<SwitchDetails> switchesList = await readSwitches();
    print(switchesList.length);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    for (var element in switchesList) {
      if (element.switchSSID == switchname) {
        element.isAutoSwitch = status;
        break;
      }
    }
    listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    await deleteSwitches();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }


  getSwitchBySSID(switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var element in switchesList) {
      if (element.switchSSID == switchSSID) return element;
    }
    return null;
  }

  getRouterByName(switchName) async {
    List<RouterDetails> routerList = await readRouters();
    for (var element in routerList) {
      if (element.name + "_" + element.switchName == switchName) return element;
    }
    return null;
  }

  getGroupByName(groupName) async {
    List<GroupDetails> groupList = await readAllGroups();
    for (var element in groupList) {
      if (element.groupName == groupName) return element;
    }
    return null;
  }

  getContactByPhone(phone) async {
    List<ContactsModel> switchesList = await readContacts();
    for (var element in switchesList) {
      if (element.name == phone) return element;
    }
    return null;
  }

  Future<bool> isSwitchSSIDExists(String switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var switchDetails in switchesList) {
      if (switchDetails.switchSSID == switchSSID) {
        return true;
      }
    }
    return false;
  }

  void addswitches(BuildContext context, SwitchDetails switchDetails) async {
    bool exists = await isSwitchSSIDExists(switchDetails.switchSSID);
    if (exists) {
      showToast(context, "Switch Name already exists.");
      return;
    }
    List<SwitchDetails> switchesList = await readSwitches();
    switchesList.add(switchDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  Future<String?> getIpAdderss(String switchID) async {
    List<RouterDetails> routerList = await readRouters();
    String? IP;
    for (var element in routerList) {
      if (element.switchID == switchID) {
        IP = element.iPAddress;
        break;
      }
    }
    return IP;
  }

  Future<List<RouterDetails>> readRouters() async {
    String? switches = await storage.read(key: "routers");
    List<RouterDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "routers", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      for (var element in jsonContacts) {
        _model.add(RouterDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneRouter(RouterDetails switchDetails) async {
    List<RouterDetails> switchList = await readRouters();
    switchList.removeWhere((element) => element.switchID == switchDetails.switchID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<bool> isSwitchIDExists(String switchID) async {
    List<RouterDetails> RouterList = await readRouters();
    for (var switchDetails in RouterList) {
      if (switchDetails.switchID == switchID) {
        return true;
      }
    }
    return false;
  }

  void addRouters(BuildContext context,RouterDetails switchDetails) async {

      List<RouterDetails> switchesList = await readRouters();
      switchesList.add(switchDetails);
      List listContectsInJson = switchesList.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<void> updateRouterDetails(String idOfSwitch, RouterDetails routerDetails) async {
    // Assuming you have a method to fetch all group details from storage
    List<RouterDetails> allRouters = await readRouters();
    print("-------------");
    List listContectsInJson = allRouters.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    // deleteOneSwitch(switchDetails);
    print(allRouters.length);
    for (var element in allRouters) {
      if (element.switchID == idOfSwitch) {
        element.switchID = element.switchID;
        element.switchName = element.switchName;
        element.privatePin = element.privatePin;
        element.switchPasskey = routerDetails.switchPasskey;
        // Keep the name, password, and ipAddress the same
        element.name = routerDetails.name;
        element.password = routerDetails.password;
        element.iPAddress = routerDetails.iPAddress;
        break;
      }
    }
    listContectsInJson = allRouters.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    await deleteGroups();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<void> cancelUpdateRouter(String idOfSwitch, String iPAddr) async {
    // Assuming you have a method to fetch all group details from storage
    List<RouterDetails> allRouters = await readRouters();
    print("-------------");
    List listContectsInJson = allRouters.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    // deleteOneSwitch(switchDetails);
    print(allRouters.length);
    for (var element in allRouters) {
      if (element.switchID == idOfSwitch) {
        element.switchID = element.switchID;
        element.switchName = element.switchName;
        element.privatePin = element.privatePin;
        element.switchPasskey = element.switchPasskey;
        // Keep the name, password, and ipAddress the same
        element.name = element.name;
        element.password = element.password;
        element.iPAddress = iPAddr;
        break;
      }
    }
    listContectsInJson = allRouters.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    await deleteGroups();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<List<MacsDetails>> readMacs() async {
    String? switches = await storage.read(key: "macs");
    List<MacsDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "macs", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      for (var element in jsonContacts) {
        _model.add(MacsDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneMacs(MacsDetails switchDetails) async {
    List<MacsDetails> switchList = await readMacs();
    switchList.removeWhere((element) => element.id == switchDetails.id);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "macs", value: json.encode(listContectsInJson));
  }

  deleteEverythingWithRespectToSwitchID(SwitchDetails switchDetails) async {
    print("Deleting all routers");
    List<RouterDetails> routerList = await readRouters();
    routerList.removeWhere((element) => element.switchID == switchDetails.switchld);
    List routerlistContectsInJson = routerList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(routerlistContectsInJson));
    print("Deleted all routers");
    print("Deleting all macs");
    List<MacsDetails> macList = await readMacs();
    macList.removeWhere(
        (element) => element.switchDetails.switchld == switchDetails.switchld);
    List maclistContectsInJson = macList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "macs", value: json.encode(maclistContectsInJson));
    print("Deleted all macs");
    print("Deleting all switches");
    deleteOneSwitch(switchDetails);
    print("Deleted all switches");
  }
 
  updateMacStatus(MacsDetails switchDetails) async {
    await deleteOneMacs(switchDetails);
    addmacs(switchDetails);
  }

  void addmacs(MacsDetails switchDetails) async {
    List<MacsDetails> switchesList = await readMacs();
    switchesList.add(switchDetails);

    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "macs", value: json.encode(listContectsInJson));
  }


  Future<void> saveGroupDetails(GroupDetails groupDetails) async {
    List<GroupDetails> groups = await readAllGroups();
    groups.add(groupDetails);
    List listContectsInJson = groups.map((e) {
      return e.toJson();
    }).toList();
    await storage.write(key: "groups", value: json.encode(listContectsInJson));
  }

  Future<List<GroupDetails>> readAllGroups() async {
    String? groupsJson = await storage.read(key: 'groups');
    if (groupsJson == null) return [];
    List<dynamic> groupsList = jsonDecode(groupsJson);
    return groupsList.map((json) => GroupDetails.fromJson(json)).toList();
  }

  Future<bool> groupExists(String groupName) async {
    // Assuming you have a method to fetch all group details from storage
    List<GroupDetails> allGroups = await readAllGroups();

    // Check if any group has the same name as the provided groupName
    return allGroups.any((group) => group.groupName == groupName);
  }

  Future<void> updateGroupDetails(GroupName,RouterName,List<RouterDetails> selectedSwitches) async {
    // Assuming you have a method to fetch all group details from storage
    List<GroupDetails> allGroups = await readAllGroups();
    print("-------------");
    List listContectsInJson = allGroups.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    // deleteOneSwitch(switchDetails);
    print(allGroups.length);
    for (var element in allGroups) {
      if (element.groupName == GroupName) {
        element.groupName = GroupName;
        element.selectedRouter = RouterName;
        element.selectedSwitches = selectedSwitches;
        break;
      }
    }
    listContectsInJson = allGroups.map((e) {
      return e.toJson();
    }).toList();
    print(listContectsInJson);
    await deleteGroups();
    storage.write(key: "groups", value: json.encode(listContectsInJson));
  }

  Future<void> deleteOneGroup(GroupDetails groupDetails) async {
    List<GroupDetails> groups = await readAllGroups();
    groups.removeWhere((group) => group.groupName == groupDetails.groupName);
    await storage.write(
      key: 'groups',
      value: jsonEncode(groups.map((group) => group.toJson()).toList()),
    );
  }

}
