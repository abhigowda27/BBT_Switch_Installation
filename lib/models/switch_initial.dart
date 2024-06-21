class SwitchDetails {
  late String switchld;
  late String switchSSID;
  late String switchPassword;
  late String iPAddress;
  String? switchPassKey;
  late bool isAutoSwitch;
  late String privatePin;

  SwitchDetails(
      {required this.switchld,
        this.switchPassKey,
        required this.switchSSID,
        required this.isAutoSwitch,
        required this.privatePin,
        required this.switchPassword,
        required this.iPAddress});

  SwitchDetails.fromJson(Map<String, dynamic> json) {
    switchld = json['SwitchId'];
    switchSSID = json['SwitchSSID'];
    switchPassword = json['SwitchPassword'];
    privatePin = json['privatePin'];
    isAutoSwitch = json['isAutoSwitch'];
    iPAddress = json['IPAddress'];
    switchPassKey = json['SwitchPasskey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SwitchId'] = switchld;
    data['SwitchSSID'] = switchSSID;
    data['isAutoSwitch'] = isAutoSwitch;
    data['privatePin'] = privatePin;
    data['SwitchPassword'] = switchPassword;
    data['IPAddress'] = iPAddress;
    data['SwitchPasskey'] = switchPassKey;
    return data;
  }

  String toSwitchQR() {
    return "$switchld,$switchSSID,$switchPassKey,$switchPassword";
  }
}
