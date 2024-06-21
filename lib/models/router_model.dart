class RouterDetails {
  late String switchID;
  late String name;
  late String password;
  late String? iPAddress;
  late String switchPasskey;
  late String switchName;
  late String privatePin;

  RouterDetails(
      {required this.switchID,
        required this.name,
        required this.password,
        this.iPAddress,
        required this.switchPasskey,
        required this.switchName,
        required this.privatePin,
      });

  RouterDetails.fromJson(Map<String, dynamic> json) {
    switchID = json['SwitchId'];
    name = json['SwitchSSID'];
    password = json['SwitchPassword'];
    switchPasskey = json['SwitchPassKey'];
    iPAddress = json['IPAddress'];
    switchName = json['SwitchName'];
    privatePin = json['privatePin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SwitchId'] = switchID;
    data['SwitchSSID'] = name;
    data['SwitchPassword'] = password;
    data['SwitchPassKey'] = switchPasskey;
    data['IPAddress'] = iPAddress;
    data['SwitchName'] = switchName;
    data['privatePin'] = privatePin;
    return data;
  }

  String toRouterQR() {
    return "$switchID,$name,$password,$switchPasskey,$iPAddress";
  }
}
