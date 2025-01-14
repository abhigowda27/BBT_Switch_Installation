class SwitchDetails {
  late String switchId;
  late String switchSSID;
  late String switchPassword;
  late String iPAddress;
  String? switchPassKey;
  late String privatePin;

  SwitchDetails(
      {required this.switchId,
      this.switchPassKey,
      required this.switchSSID,
      required this.privatePin,
      required this.switchPassword,
      required this.iPAddress});

  SwitchDetails.fromJson(Map<String, dynamic> json) {
    switchId = json['SwitchId'];
    switchSSID = json['SwitchSSID'];
    switchPassword = json['SwitchPassword'];
    privatePin = json['privatePin'];
    iPAddress = json['IPAddress'];
    switchPassKey = json['SwitchPasskey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SwitchId'] = switchId;
    data['SwitchSSID'] = switchSSID;
    data['privatePin'] = privatePin;
    data['SwitchPassword'] = switchPassword;
    data['IPAddress'] = iPAddress;
    data['SwitchPasskey'] = switchPassKey;
    return data;
  }

  String toSwitchQR() {
    return "$switchId,$switchSSID,$switchPassKey,$switchPassword";
  }
}
