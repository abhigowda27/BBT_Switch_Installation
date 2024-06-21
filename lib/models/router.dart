// class SwitchDetails {
//   String? switchld;
//   String? switchSSID;
//   String? routerSSID;
//   String? routerPassword;
//   String? iPAddress;
//   String? switchPassKey;
//
//   SwitchDetails(
//       {this.switchld,
//         this.switchSSID,
//       this.switchPassKey,
//       this.routerSSID,
//       this.routerPassword,
//       this.iPAddress}
//       );
//
//   SwitchDetails.fromJson(Map<String, dynamic> json) {
//     switchld = json['SwitchId'];
//     switchSSID = json['SwitchSSID'];
//     routerSSID = json['RouterSSID'];
//     routerPassword = json['RouterPassword'];
//     iPAddress = json['IPAddress'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['SwitchId'] = this.switchld;
//     data['SwitchSSID'] = this.switchSSID;
//     data['RouterSSID'] = this.routerSSID;
//     data['RouterPassword'] = this.routerPassword;
//     data['IPAddress'] = this.iPAddress;
//     data['SwitchPasskey'] = this.switchPassKey;
//     return data;
//   }
// }