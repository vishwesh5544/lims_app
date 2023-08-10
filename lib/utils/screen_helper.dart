import 'package:flutter/material.dart';
import 'package:lims_app/utils/text_utility.dart';

class ScreenHelper {
  static Future<void> showAlertPopup(String message, BuildContext context,
      {Duration duration = const Duration(seconds: 3)}) async {
    showDialog<void>(
      context: context,
      builder: (context) {
        // Future.delayed(duration, () {
        //   Navigator.of(context).pop();
        // });
        return AlertDialog(
            content: Text(message, style: TextUtility.getBoldStyle(12.0, color: Colors.black)),
            actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close"))]);
      },
    );
  }
}
