import '../models/switch_model.dart';
import 'storage.dart';

class RouterAddController {
  StorageController storageController = StorageController();
  Future<String?> fetchSwitches(connectionStatus) async {
    List<SwitchDetails> switchDetails = await storageController.readSwitches();
    for (var e in switchDetails) {
      if (e.switchSSID == connectionStatus) {
        // if (e.switchSSID == connectionStatus) {
        return e.switchPassKey;
      }
    }
    switchDetails.map((e) {
      if (e.switchSSID == connectionStatus) {
        // if (e.switchSSID == connectionStatus) {
        return e.switchPassKey;
      }
    });
    return null;
  }
}
