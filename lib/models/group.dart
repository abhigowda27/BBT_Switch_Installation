import 'router_model.dart';

class GroupDetails {
  late String groupName;
  late String selectedRouter;
  late List<RouterDetails> selectedSwitches;

  GroupDetails({
    required this.groupName,
    required this.selectedRouter,
    required this.selectedSwitches,
  });

  GroupDetails.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    selectedRouter = json['selectedRouter'] ;
    var switchList = json['selectedSwitches'] as List;
    selectedSwitches = switchList.map((e) => RouterDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupName'] = groupName;
    data['selectedRouter'] = selectedRouter;
    data['selectedSwitches'] = selectedSwitches.map((e) => e.toJson()).toList();
    return data;
  }

  String toGroupQR() {
    String switchesQR = selectedSwitches.map((switchDetails) => switchDetails.toRouterQR()).join(",");
    return "$groupName,$selectedRouter,[$switchesQR]";
  }

}
