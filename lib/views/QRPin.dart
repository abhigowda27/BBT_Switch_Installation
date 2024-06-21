import 'package:flutter/material.dart';
import '../controllers/storage.dart';
import '../widgets/toast.dart';

class PinDialog {
  final BuildContext context;
  final StorageController _storageController = StorageController();

  PinDialog(this.context);

  Future<void> showPinDialog({
    required bool isFirstTime,
    required Function onSuccess,
  }) async {
    TextEditingController pinController = TextEditingController();
    TextEditingController confirmPinController = TextEditingController();
    TextEditingController oldPinController = TextEditingController();

    bool isResettingPin = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: isFirstTime
                  ? const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set QR PIN'),
                  SizedBox(height: 4), // Adjust the spacing as needed
                  Text(
                    'You Need to Remember this PIN for Generating QR code for switches',
                    style: TextStyle(fontSize: 12), // Smaller text size
                  ),
                ],
              )
                  : Text(isResettingPin ? 'Reset QR PIN' : 'Enter QR PIN'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isResettingPin) ...[
                      TextField(
                        controller: oldPinController,
                        decoration: const InputDecoration(hintText: 'Enter Old PIN'),
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                      const SizedBox(height: 8),
                    ],
                    TextField(
                      controller: pinController,
                      decoration: InputDecoration(
                        hintText: isResettingPin ? 'Enter New PIN' : 'Enter PIN',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                    ),
                    if (isResettingPin) ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: confirmPinController,
                        decoration: const InputDecoration(hintText: 'Confirm New PIN'),
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                if (!isFirstTime)
                  TextButton(
                    child: const Text('Reset PIN'),
                    onPressed: () {
                      setState(() {
                        isResettingPin = true;
                      });
                    },
                  ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    if (pinController.text.length != 4 ||
                        (isResettingPin && confirmPinController.text.length != 4)) {
                      showToast(context, 'PIN must be 4 digits.');
                      return;
                    }

                    if (isResettingPin) {
                      final storedPin = await _storageController.getQrPin();
                      if (storedPin != oldPinController.text) {
                        showToast(context, 'Old PIN is incorrect. Please try again.');
                        return;
                      }
                      if (pinController.text != confirmPinController.text) {
                        showToast(context, 'New PINs do not match. Please try again.');
                        return;
                      }
                      await _storageController.setQrPin(pinController.text);
                      showToast(context, 'PIN has been reset successfully.');
                    } else {
                      if (isFirstTime) {
                        await _storageController.setQrPin(pinController.text);
                      } else {
                        final storedPin = await _storageController.getQrPin();
                        if (storedPin != pinController.text) {
                          showToast(context, 'Invalid PIN. Please try again.');
                          return;
                        }
                      }
                    }
                    Navigator.of(context).pop();
                    onSuccess();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}