// class APMode {
//   late String switchID;
//   late String switchName;
//   late String switchPassword;
//   late String iPAddress;
//   late String switchPasskey;
//
//   APMode(
//       {required this.switchID,
//       required this.switchName,
//       required this.switchPassword,
//       required this.iPAddress,
//       required this.switchPasskey});
//
//   APMode.fromJson(Map<String, dynamic> json) {
//     switchID = json['SwitchId'];
//     switchName = json['SwitchSSID'];
//     switchPassword = json['SwitchPassword'];
//     switchPasskey = json['SwitchPassKey'];
//     iPAddress = json['IPAddress'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['SwitchId'] = switchID;
//     data['SwitchSSID'] = switchName;
//     data['SwitchPassword'] = switchPassword;
//     data['IPAddress'] = iPAddress;
//     return data;
//   }
// }
